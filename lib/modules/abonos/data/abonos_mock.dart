class Abono {
  final String cliente;
  final String pedido;
  final String metodo;
  final String fecha;
  final double monto;

  Abono({
    required this.cliente,
    required this.pedido,
    required this.metodo,
    required this.fecha,
    required this.monto,
  });
}

List<Abono> abonosMock = [
  Abono(
    cliente: "Alessandro V. Rossi",
    pedido: "#PIX-9921",
    metodo: "Transferencia Digital",
    fecha: "Oct 24, 2023",
    monto: 1250.00,
  ),
  Abono(
    cliente: "Luna Marquee Designs",
    pedido: "#PIX-8840",
    metodo: "Tarjeta de Crédito",
    fecha: "Oct 22, 2023",
    monto: 840.50,
  ),
  Abono(
    cliente: "The Urban Boutique",
    pedido: "#PIX-7762",
    metodo: "Transferencia Digital",
    fecha: "Oct 20, 2023",
    monto: 2100.00,
  ),
  Abono(
    cliente: "Evelyn Craft Studio",
    pedido: "#PIX-6619",
    metodo: "Efectivo",
    fecha: "Oct 19, 2023",
    monto: 320.00,
  ),
];
