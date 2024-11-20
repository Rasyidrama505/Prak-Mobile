import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:online_shop/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart';
import 'user.dart';
import 'home_admin.dart'; // Import halaman admin

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Cek apakah username dan password adalah admin
    if (username == 'admin' && password == 'admin') {
      // Simpan status login admin
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAdmin', true);

      // Navigasi ke HomeAdmin
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  HomeAdmin()),
      );
      return;
    }

    // Cek user biasa dari Hive database
    final box = Hive.box<User>('users');
    final user = box.values.firstWhere(
      (user) => user.username == username && user.password == password,
      orElse: () => User(username: '', password: ''),
    );

    if (user.username.isNotEmpty) {
      // Simpan status login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Login berhasil
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Berhasil'),
          content: Text('Selamat datang, $username!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Login gagal
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kesalahan'),
          content: const Text('Username atau password salah.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _icon(),
                        const SizedBox(height: 30),
                        _inputText("Username", _usernameController),
                        const SizedBox(height: 10),
                        _inputText("Password", _passwordController, isPassword: true),
                        const SizedBox(height: 20),
                        _loginButton(),
                        const SizedBox(height: 10),
                        _signUpButton(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _icon() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        'assets/images/shop.jpeg', // Pastikan gambar ini ada di folder assets
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.width * 0.5,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _inputText(String hintText, TextEditingController controller,
      {bool isPassword = false}) {
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

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Log in",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      },
      child: const Text(
        "Create account",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}
