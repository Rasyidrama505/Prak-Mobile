import 'package:flutter/material.dart';
import 'package:online_shop/api_service.dart';
import 'package:online_shop/cart_provider.dart';
import 'package:online_shop/hive_provider.dart';
import 'package:online_shop/login_page.dart'; // Import LoginPage
import 'package:online_shop/user.dart';
import 'package:online_shop/checkout_provider.dart'; // Import CheckoutProvider
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive Flutter

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan binding sudah terinisialisasi
  
  // Inisialisasi Hive
  await Hive.initFlutter();
  
  // Register Adapter untuk User
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  
  // Buka box yang diperlukan
  await Hive.openBox<User>('users');
  await Hive.openBox('settings');
  await Hive.openBox<ProductModel>('products'); 

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider<HiveProvider>(
          create: (_) => HiveProvider(),
        ),
        ChangeNotifierProvider<CheckoutProvider>(
          create: (_) => CheckoutProvider(), // Tambahkan CheckoutProvider
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            return  LoginPage(); // Jika sudah login, tampilkan HomeScreen
          } else {
            return LoginPage(); // Jika belum login, tampilkan LoginPage
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Mengambil status login
  }
}