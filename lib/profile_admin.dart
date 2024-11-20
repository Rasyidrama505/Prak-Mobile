import 'package:flutter/material.dart';
import 'login_page.dart'; // Import halaman login

class ProfileAdmin extends StatelessWidget {
  const ProfileAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Admin"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gambar avatar admin
              const SizedBox(
                width: 250,
                height: 250,
                child: CircleAvatar(
                  radius: 125,
                  // backgroundImage: AssetImage(''),
                ),
              ),
              const SizedBox(height: 20), // Jarak antara gambar dan teks

              // Nama dan NIM
              const Text(
                "Admin",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5), // Jarak antara nama dan NIM

              const Text(
                "124220119",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20), // Jarak antara NIM dan saran/kesan

              // Saran dan Kesan
              const Text(
                "Saran: Belajar Lagi ya Dek Ya",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 5), // Jarak antara teks saran dan kesan
              const Text(
                "Kesan: Belajar itu penting",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30), // Jarak antara kesan dan tombol logout

              // Tombol Logout
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Sudut tombol bulat
                  ),
                  backgroundColor: Colors.red, // Warna tombol merah
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
