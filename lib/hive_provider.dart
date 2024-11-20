import 'package:flutter/foundation.dart';
import 'package:online_shop/user.dart';

class HiveProvider with ChangeNotifier {
  final List<ProductModel> _cartItems = []; // List untuk menyimpan produk

  List<ProductModel> get cartItems => _cartItems;

  // Menambahkan produk ke keranjang
  void addToCart(ProductModel produk) {
    _cartItems.add(produk);
    notifyListeners();
  }

  // Menghapus produk dari keranjang
  void removeFromCart(ProductModel produk) {
    _cartItems.remove(produk);
    notifyListeners();
  }

  // Menghapus semua produk di keranjang
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Menghitung total harga
  double get totalPrice {
    return _cartItems.fold(0.0, (total, item) => total + item.price);
  }

  // Memeriksa apakah produk ada di keranjang
  bool isInCart(ProductModel product) {
    return _cartItems.contains(product);
  }
}
