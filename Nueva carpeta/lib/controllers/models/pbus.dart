enum Pbus {
  ack(255),
  reset(254),
  bootMode(253),
  fwdata(252),
  chnetaddr(251),
  factory(250),
  info(249),
  response(248);

  const Pbus(this.id);
  final int id;
}