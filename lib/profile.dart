import 'package:flutter/material.dart';
import 'package:online_shop/creator.dart'; // Pastikan import CreatorScreen dengan benar
import 'package:online_shop/history.dart'; // Import halaman history
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigasi kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol Creator
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Warna latar belakang
                foregroundColor: Colors.white, // Warna teks
                minimumSize: const Size(double.infinity, 60), // Ukuran tombol
              ),
              onPressed: () {
                // Navigasi ke halaman CreatorScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatorScreen()),
                );
              },
              child: const Text("Creator"),
            ),
            const SizedBox(height: 16), // Jarak antar tombol

            // Tombol Your Order (Sekarang navigasi ke HistoryScreen)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Warna latar belakang
                foregroundColor: Colors.white, // Warna teks
                minimumSize: const Size(double.infinity, 60), // Ukuran tombol
              ),
              onPressed: () {
                // Navigasi ke halaman HistoryScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
              child: const Text("Your Order"),
            ),
            const SizedBox(height: 16), // Jarak antar tombol

            // Tombol Logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna latar belakang
                foregroundColor: Colors.white, // Warna teks
                minimumSize: const Size(double.infinity, 60), // Ukuran tombol
              ),
              onPressed: () async {
                // Logout dan kembali ke halaman login
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false); // Menghapus status login

                // Navigasi kembali ke halaman login
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}