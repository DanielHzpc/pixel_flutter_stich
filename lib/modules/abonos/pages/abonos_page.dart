// ================== ABONOS PAGE (DISEÑO FIEL AL MOCKUP) ==================
import 'package:flutter/material.dart';
import '../data/abonos_mock.dart';
import '../../../shared/customBottonNav.dart';
import '../../../shared/customTopBar.dart';

class AbonosPage extends StatefulWidget {
  const AbonosPage({super.key});

  @override
  State<AbonosPage> createState() => _AbonosPageState();
}

class _AbonosPageState extends State<AbonosPage> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            CustomTopBar(),
            const SizedBox(height: 25),
            _header(),
            const SizedBox(height: 25),
            _cardsResumen(),
            const SizedBox(height: 15),
            _eficiencia(),
            const SizedBox(height: 30),

            // --- CONTENEDOR GRIS DEL HISTORIAL ---
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF0F3), // Gris del fondo del historial
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _historialHeader(),
                  const SizedBox(height: 20),
                  // Generación dinámica de tarjetas desde la lista
                  ...abonosMock.map((item) => _itemTransaccion(item)).toList(),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Cargar más transacciones",
                      style: TextStyle(
                        color: Color(0xFF6C4EFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- COMPONENTES SUPERIORES ---

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "LIBRO DEL ARTESANO",
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF6B2FD9),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
            children: [
              TextSpan(text: "Pagos y "),
              TextSpan(
                text: "Abonos",
                style: TextStyle(color: Color(0xFFC2185B)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Gestiona el flujo de caja de tu estudio creativo con precisión. Seguimiento de contribuciones de artesanos y saldos de producción.",
          style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
        ),
      ],
    );
  }

  Widget _cardsResumen() {
    return Column(
      children: [
        _resumenTile(
          "TOTAL ABONOS",
          "\$12,840.00",
          "+12% este mes",
          const Color(0xFF6C4EFF),
          Icons.account_balance_wallet_outlined,
        ),
        const SizedBox(height: 12),
        _resumenTile(
          "SALDO PENDIENTE",
          "\$4,210.50",
          "8 pagos pendientes",
          const Color(0xFFC2185B),
          Icons.calendar_today,
        ),
      ],
    );
  }

  Widget _resumenTile(
    String title,
    String val,
    String sub,
    Color col,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: col, width: 5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                val,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sub,
                style: TextStyle(
                  color: col,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _eficiencia() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF0288D1), Color(0xFF01579B)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "EFICIENCIA RECIENTE",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "98.2%",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Tasa de cobro puntual",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // --- COMPONENTES DEL HISTORIAL ---

  Widget _historialHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Historial\nReciente",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFDCDDE2),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(children: [_tab("Semanal", false), _tab("Mensual", true)]),
        ),
      ],
    );
  }

  Widget _tab(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF6C4EFF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.black54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- TARJETA DE TRANSACCIÓN INDIVIDUAL ---
  Widget _itemTransaccion(Abono a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E9FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF6C4EFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.cliente,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "PEDIDO ${a.pedido}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _datoPeque("FECHA", a.fecha)),
              Expanded(child: _datoPeque("MÉTODO", a.metodo)),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "MONTO",
            style: TextStyle(
              color: Color(0xFFC2185B),
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${a.monto.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              // ICONO PDF MORADO
              const Icon(
                Icons.picture_as_pdf_rounded,
                color: Color(0xFF6C4EFF),
                size: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _datoPeque(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
