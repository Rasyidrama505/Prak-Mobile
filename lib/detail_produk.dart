import 'package:flutter/material.dart';
import 'package:online_shop/keranjang.dart';
import 'package:online_shop/profile.dart';
import 'package:provider/provider.dart';
import 'product_model.dart';
import 'cart_provider.dart'; // Import CartProvider

class DetailProdukScreen extends StatelessWidget {
  final Product product;

  const DetailProdukScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'YARD Sale',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false, // Menghilangkan tombol back otomatis
        actions: [
          Row(
            children: [
              const SizedBox(width: 10),
              // Ikon keranjang yang sama dengan HomeScreen
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman Keranjang
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KeranjangScreen()),
                  );
                },
                child: const Icon(
                  Icons.shopping_cart, // Ikon yang sesuai
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                        onTap: () {
    // Navigasi ke halaman profile.dart
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  },
  child: const Icon(
    Icons.person,
    color: Colors.white,
    size: 30,
  ),
                      ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Menavigasi kembali ke halaman sebelumnya
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            // Gambar Produk
            Image.network(
              product.images.isNotEmpty ? product.images[0] : 'https://via.placeholder.com/150',
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            // Judul Produk
            Text(
              product.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Harga Produk
            Text(
              'Price: \$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            // Deskripsi Produk
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
            const SizedBox(height: 16),
            // Tombol Add to Cart
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Menambahkan produk ke keranjang
                  final cart = Provider.of<CartProvider>(context, listen: false);
                  cart.addToCart(product); // Fungsi untuk menambahkan produk ke keranjang
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.title} added to cart!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
