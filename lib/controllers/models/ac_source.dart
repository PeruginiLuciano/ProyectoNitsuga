import 'package:motorhome/controllers/models/packet.dart';

enum AcSource {
  line, generator, inverter, none;

  static AcSource fromPacket(Packet packet) {
    if (packet.byte1 == 0) return AcSource.line;
    if (packet.byte2 == 0) return AcSource.generator;
    if (packet.byte3 == 0) return AcSource.inverter;
    return AcSource.none;
  }
}