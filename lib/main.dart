import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'login_screen.dart';
import 'modules/abonos/pages/abonos_page.dart';
import 'pedidos.dart';
import 'production.dart';
import 'perfil.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android:
                CupertinoPageTransitionsBuilder(), // O ZoomPageTransitionsBuilder()
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/pedidos': (_) => const PedidosPage(),
        '/pagos': (_) => const AbonosPage(),
        '/produccion': (_) => const ProductionScreen(),
        '/perfil': (_) => const PerfilScreen(),
      },
    );
  }
}
