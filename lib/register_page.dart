import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:online_shop/login_page.dart';
import 'user.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register(BuildContext context) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final box = Hive.box<User>('users');
    final userExists = box.values.any((user) => user.username == username);

    if (userExists) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kesalahan'),
          content: const Text('Username sudah terdaftar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      final user = User(username: username, password: password);
      await box.add(user);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Akun berhasil dibuat!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Kembali ke LoginPage
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Mendapatkan ukuran layar
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _page(context, size),
      ),
    );
  }

  Widget _page(BuildContext context, Size size) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1), // Padding dinamis
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _icon(size),
            const SizedBox(height: 50),
            _inputField("Username", _usernameController),
            const SizedBox(height: 10),
            _inputField("Password", _passwordController, isPassword: true),
            const SizedBox(height: 30),
            _registerButton(context),
            const SizedBox(height: 5),
            _loginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _icon(Size size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        'assets/images/shop.jpeg', // Pastikan gambar ini ada di folder assets
        width: size.width * 0.5, // Ukuran responsif
        height: size.width * 0.5, // Ukuran responsif
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller, {bool isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.black54),
    );

    return TextField(
      style: const TextStyle(color: Colors.black87),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

  Widget _registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _register(context),
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: const Text(
        "Already have an account?",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: Colors.black54),
      ),
    );
  }
}
