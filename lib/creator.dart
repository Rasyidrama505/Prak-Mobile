import 'package:flutter/material.dart';

class CreatorScreen extends StatelessWidget {
  const CreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Creator"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: const Center( // Membuat seluruh isi halaman berada di tengah
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten secara vertikal
            crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan konten secara horizontal
            children: [
              // Gambar avatar anggota tim
              SizedBox(
                width: 250,  // Lebar gambar
                height: 250, // Tinggi gambar
                child: CircleAvatar(
                  radius: 125, // Ukuran lingkaran gambar
                  backgroundImage: AssetImage('assets/images/zola.jpeg'),
                ),
              ),
              SizedBox(height: 20), // Jarak antara gambar dan teks

              // Nama dan NIM
              Text(
                "Zola Dimas Firmansyah",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5), // Jarak antara nama dan NIM

              Text(
                "124220106",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20), // Jarak antara NIM dan saran/kesan

              // Saran dan Kesan
              Text(
                "Saran: Belajar Lagi ya Dek Ya",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 5), // Jarak antar teks saran dan kesan
              Text(
                "Kesan: Belajar itu penting",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
