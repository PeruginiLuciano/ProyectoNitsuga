import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/channelMethod.dart';
import 'package:motorhome/controllers/models/devices/aaa100.dart';
import 'package:motorhome/controllers/models/devices/acc200.dart';
import 'package:motorhome/controllers/models/devices/ca102.dart';
import 'package:motorhome/controllers/models/devices/caa10.dart';
import 'package:motorhome/controllers/models/devices/ctrlcal100.dart';
import 'package:motorhome/controllers/models/devices/prm200.dart';
import 'package:motorhome/controllers/models/devices/rgb100.dart';
import 'package:motorhome/controllers/models/devices/sg100.dart';
import 'package:motorhome/controllers/models/devices/tank100.dart';
import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/controllers/models/devices/prc10.dart';
import 'package:motorhome/controllers/models/devices/tmh10.dart';
import 'package:motorhome/controllers/models/pbus.dart';
import 'package:synchronized/synchronized.dart';

class CommunicationController extends GetxController {

  late final Prc10 prc10;
  late final Tmh10 tmh10;
  late final Aaa100 aaa100;
  late final Caa10 caa10;
  late final Ctrlcal100 ctrlcal100;
  late final Sg100 sg100;
  late final Rgb100 rgb100;
  late final Ca102 ca102;
  late final Tank100 tank100;
  late final Prm200 prm200;
  late final Acc200 acc200;

  var outputPackets = <Packet>[];
  var lock = Lock();

  CommunicationController() {
    prc10 = Prc10(_write);
    tmh10 = Tmh10(_write);
    aaa100 = Aaa100(_write);
    caa10 = Caa10(_write);
    ctrlcal100 = Ctrlcal100(_write);
    sg100 = Sg100(_write);
    rgb100 = Rgb100(_write);
    ca102 = Ca102(_write);
    tank100 = Tank100(_write);
    prm200 = Prm200(_write);
    acc200 = Acc200(_write);

    init();
  }

  static const MethodChannel _channel = MethodChannel("com.motorhome.method.channel");
  static const EventChannel _events = EventChannel('com.motorhome.event.channel');
  Timer? _openConnectionTimer, _readTimer;

  Future init() async {
    _events.receiveBroadcastStream().listen(_eventsListener);
    open();
  }

  void _eventsListener(event) {

  }

  Future open() async {
    try {
      if (kDebugMode) {
        print("Opening UART");
      }
      bool result = await _channel.invokeMethod(ChannelMethod.open.name);
      if (result) {
        _openConnectionTimer?.cancel();
        _openConnectionTimer = null;
      }
      _readTimer = Timer.periodic(const Duration(milliseconds: 100), _readWriteTask);
    } on Exception catch (e) {
      if (kDebugMode) {
        // print("Error opening UART: $e");
      }
      _initOpenConnectionTimer();
    }
  }

  Future _initOpenConnectionTimer() async {
    _openConnectionTimer ??= Timer.periodic(const Duration(seconds: 3), (timer) {
      open();
    });
  }

  void _readWriteTask(Timer timer) async {
    // write
    lock.synchronized(() async {
      if (outputPackets.isNotEmpty) {
        try {
          print("Sending >> ${outputPackets[0].toBytes()}");
          await _channel.invokeMethod(
              ChannelMethod.write.name, <String, dynamic>{'bytes': outputPackets[0].toBytes()}
          );
          outputPackets.removeAt(0);
        } on Exception catch (e) {
          if (kDebugMode) {
            print("Error writing: $e");
          }
        }
      }
      // read
      try {
        List<int>? packet = await _channel.invokeMethod(ChannelMethod.read.name);
        // print("Read: $packet");
        if (packet != null && packet.isNotEmpty) {
          logOutput(packet);
          processCommand(packet);
        }
        // await Future.delayed(const Duration(milliseconds: 500));
      } on Exception catch (e) {
        if (kDebugMode) {
          print("Error reading: $e");
        }
      }
    });
  }

  Future logOutput(List<int> result) async {
    var output = "Received ";
    for (var element in result) {
      output += " 0x${element.toRadixString(16)}";
    }
    print(output);
  }

  void _write(Packet packet) => lock.synchronized(() => outputPackets.add(packet));

  Future<bool> _writeAsync(Packet packet) async {
    try {
      print("Sending ${packet.toBytes()}");
      int? result = await _channel.invokeMethod(ChannelMethod.write.name, <String, dynamic>{'bytes': packet.toBytes()});
      if (result != null && result > 0) {
        return true;
      }
    } on Exception catch(e) {
      if (kDebugMode) {
        print("Error writing: $e");
      }
    }
    return false;
  }

  Future processCommand(List<int> packetBytes) async {
    var packet = Packet.fromBytes(packetBytes);
    if (packet.commandNumber == Pbus.response.id) {
      switch (packet.origin) {
        case Address.prc10:
          prc10.processCommand(packet);
          break;
        case Address.aaa100:
          aaa100.processCommand(packet);
          break;
        case Address.caa10:
          caa10.processCommand(packet);
          break;
        case Address.ctrlcal100:
          ctrlcal100.processCommand(packet);
          break;
        case Address.sg100:
          sg100.processCommand(packet);
          break;
        case Address.rgb100:
          rgb100.processCommand(packet);
          break;
        case Address.ca102:
          ca102.processCommand(packet);
          break;
        case Address.tank100:
          tank100.processCommand(packet);
          break;
        case Address.prm200:
          prm200.processCommand(packet);
          break;
        case Address.acc200:
          acc200.processCommand(packet);
          break;
        case Address.broadcast:
          // Not implemented
          break;
        default:
      }
    } else {
      tmh10.processCommand(packet);
    }
  }
}