import 'package:flutter/material.dart';
import 'shared/customBottonNav.dart';
import 'shared/customTopBar.dart';

void main() {
  runApp(const MyApp());
}

/// ENUM DE ESTADOS
enum EstadoPedido {
  enDiseno,
  enProduccion,
  listo,
  entregado,
}

/// MODELO
class Pedido {
  final String? id;
  final String? cliente;
  final double precio;
  final DateTime fecha;
  final DateTime? fechaEntrega;
  final EstadoPedido estado;
  final double progreso;

  Pedido({
    required this.id,
    required this.cliente,
    required this.precio,
    required this.fecha,
    this.fechaEntrega,
    required this.estado,
    required this.progreso,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PedidosPage(),
    );
  }
}

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  EstadoPedido? filtro;
  int currentIndex = 0;
  String? searchText;

  /// 🔥 DATOS QUEMADOS
  final List<Pedido> pedidos = [
    Pedido(
      id: "PX-9042",
      cliente: "Elena Rodriguez",
      precio: 1240000,
      fecha: DateTime(2023, 10, 24),
      estado: EstadoPedido.enProduccion,
      progreso: 0.75,
    ),
    Pedido(
      id: "PX-8812",
      cliente: "Marcus Chen",
      precio: 800000,
      fecha: DateTime(2023, 10, 28),
      estado: EstadoPedido.enDiseno,
      progreso: 0.3,
    ),
    Pedido(
      id: "PX-8756",
      cliente: "Sarah Jenkins",
      precio: 650000,
      fecha: DateTime(2023, 10, 22),
      fechaEntrega: DateTime(2023, 10, 22),
      estado: EstadoPedido.entregado,
      progreso: 1,
    ),
    Pedido(
      id: "PX-9100",
      cliente: "Carlos Pérez",
      precio: 500000,
      fecha: DateTime(2023, 10, 30),
      estado: EstadoPedido.listo,
      progreso: 0.95,
    ),
  ];

  /// 🔍 FILTRO + BUSCADOR (SIN ERRORES)
  List<Pedido> get pedidosFiltrados {
    return pedidos.where((p) {
      final textoBusqueda = (searchText ?? '').toLowerCase();

      final id = (p.id ?? '').toLowerCase();
      final cliente = (p.cliente ?? '').toLowerCase();

      final coincideBusqueda =
          id.contains(textoBusqueda) || cliente.contains(textoBusqueda);

      final coincideEstado = filtro == null || p.estado == filtro;

      return coincideBusqueda && coincideEstado;
    }).toList();
  }

  /// 📅 FORMATO FECHA
  String formatearFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  /// TEXTO ESTADO
  String estadoTexto(EstadoPedido estado) {
    switch (estado) {
      case EstadoPedido.enDiseno:
        return "En diseño";
      case EstadoPedido.enProduccion:
        return "En producción";
      case EstadoPedido.listo:
        return "Listo";
      case EstadoPedido.entregado:
        return "Entregado";
    }
  }

  /// COLOR ESTADO
  Color estadoColor(EstadoPedido estado) {
    switch (estado) {
      case EstadoPedido.enDiseno:
        return Colors.grey;
      case EstadoPedido.enProduccion:
        return Colors.pink;
      case EstadoPedido.listo:
        return Colors.orange;
      case EstadoPedido.entregado:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// HEADER
              CustomTopBar(),

              const SizedBox(height: 5),

              /// TITULO
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pedidos",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔍 BUSCADOR
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Buscar ID o cliente...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// DROPDOWN
              DropdownButtonFormField<EstadoPedido>(
                hint: const Text("Filtrar por estado"),
                items: [
                  const DropdownMenuItem(value: null, child: Text("Todos")),
                  ...EstadoPedido.values.map((estado) {
                    return DropdownMenuItem(
                      value: estado,
                      child: Text(estadoTexto(estado)),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    filtro = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// LISTA
              Expanded(
                child: ListView.builder(
                  itemCount: pedidosFiltrados.length,
                  itemBuilder: (context, index) {
                    final p = pedidosFiltrados[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ESTADO
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: estadoColor(p.estado),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              estadoTexto(p.estado),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// ID + PRECIO
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("#${p.id ?? ''}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("\$${p.precio.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                      color: Color(0xFF6C3BFF))),
                            ],
                          ),

                          const SizedBox(height: 4),

                          Text("Cliente: ${p.cliente ?? ''}"),

                          /// FECHAS
                          Text("Pedido: ${formatearFecha(p.fecha)}"),

                          if (p.estado == EstadoPedido.entregado &&
                              p.fechaEntrega != null) ...[
                            Text(
                                "Entregado: ${formatearFecha(p.fechaEntrega!)}"),
                            const SizedBox(height: 10),
                          ],

                          const SizedBox(height: 10),

                          /// PROGRESO
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Progreso",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                "${(p.progreso * 100).round()}%",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C3BFF),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: p.progreso,
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}
