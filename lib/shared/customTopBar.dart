import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos SafeArea para que no se pegue a la cámara/notch del celular
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botón de Perfil
            GestureDetector(
              onTap: () {
                // Aquí puedes navegar a la ruta de perfil cuando la tengas
                // Navigator.pushNamed(context, '/perfil');
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(Icons.person_outline, size: 20),
              ),
            ),

            // Título Central
            const Text(
              "Pixel",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            // Botón de Búsqueda
            IconButton(
              onPressed: () {
                print("Buscando...");
              },
              icon: const Icon(Icons.search, color: Color(0xFF6C4EFF)),
            ),
          ],
        ),
      ),
    );
  }

  // Esto es necesario al usar PreferredSizeWidget
  // Define el alto de tu barra (normalmente 60 a 80 px)
  @override
  Size get preferredSize => const Size.fromHeight(70);
}
