import 'dart:typed_data';

import 'package:motorhome/controllers/models/address.dart';

class Packet {
  late Address origin;
  late Address destination;
  late int commandNumber;
  late int byte1;
  late int byte2;
  late int byte3;
  late int byte4;
  late int byte5;

  Packet(
      this.origin,
      this.destination,
      this.commandNumber,
      [
        this.byte1 = 0,
        this.byte2 = 0,
        this.byte3 = 0,
        this.byte4 = 0,
        this.byte5 = 0,
      ]
  );

  Packet.fromBytes(List<int> packetBytes) {
    origin = Address.fromByte(packetBytes[0]);
    destination = Address.fromByte(packetBytes[1]);
    commandNumber = packetBytes[2];
    byte1 = packetBytes[3];
    byte2 = packetBytes[4];
    byte3 = packetBytes[5];
    byte4 = packetBytes[6];
    byte5 = packetBytes[7];
  }
  
  List<int> toBytes() => Uint8List.fromList(
      [origin.addressNumber, destination.addressNumber, commandNumber, byte1, byte2, byte3, byte4, byte5]
  );
}