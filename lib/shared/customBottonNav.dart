import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  // Recibimos el índice activo de la pantalla actual
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  // Lógica de navegación
  void _onItemTapped(BuildContext context, int index) {
    // Si presionas el botón de la vista en la que ya estás, no hace nada
    if (currentIndex == index) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/pedidos');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/pagos');
        break;
      case 2:
        // Asumo que "RASTREO" va a la ruta de producción que tienes en main.dart
        Navigator.pushReplacementNamed(context, '/produccion');
        break;
      case 3:
        // ¡Nota importante! Aún no tienes la ruta '/perfil' en tu main.dart.
        // Asegúrate de agregarla, por ahora dejaré la estructura lista.
        Navigator.pushReplacementNamed(context, '/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.receipt_long,
            label: "PEDIDOS",
            index: 0,
            currentIndex: currentIndex,
            onTap: () => _onItemTapped(context, 0),
          ),
          _NavItem(
            icon: Icons.payments_outlined,
            label: "PAGOS",
            index: 1,
            currentIndex: currentIndex,
            onTap: () => _onItemTapped(context, 1),
          ),
          _NavItem(
            icon: Icons.precision_manufacturing,
            label: "RASTREO",
            index: 2,
            currentIndex: currentIndex,
            onTap: () => _onItemTapped(context, 2),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: "PERFIL",
            index: 3,
            currentIndex: currentIndex,
            onTap: () => _onItemTapped(context, 3),
          ),
        ],
      ),
    );
  }
}

// Widget privado para los items de la barra
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEAE6FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isActive ? const Color(0xFF6C3BFF) : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? const Color(0xFF6C3BFF) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
