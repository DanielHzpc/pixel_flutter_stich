class AuthService {
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'usuario@correo.com' && password == '123456') {
      return; // éxito
    } else {
      throw Exception('Credenciales incorrectas');
    }
  }
}