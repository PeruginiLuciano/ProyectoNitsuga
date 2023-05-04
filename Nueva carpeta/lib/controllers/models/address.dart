enum Address {
  prc10(4),       // Placa rele
  aaa100(6),      // Aire acondicionado
  caa10(23),      // Aire frio/calor
  ctrlcal100(7),  // Calefactor a gasoil
  sg100(9),       // Sensor de gas
  rgb100(11),     // Luces RGB
  ca102(13),      // Potencia de audio
  tank100(17),    // Tanques de agua
  tmh10(5),       // Pantalla touch
  prm200(25),     // Nivelador
  acc200(15),     // Acelerometro
  broadcast(255), // Broadcast
  local(0);

  const Address(this.addressNumber);
  final int addressNumber;

  static Address fromByte(int addressByte) => Address.values.firstWhere((e) => e.addressNumber == addressByte, orElse: () => Address.local);
}
