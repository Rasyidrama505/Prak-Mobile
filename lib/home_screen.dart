import 'package:flutter/material.dart';
import 'package:online_shop/hive_provider.dart';
import 'package:online_shop/profile.dart';
import 'package:online_shop/user.dart';
import 'package:provider/provider.dart';
import 'detail_produk.dart';
import 'cart_provider.dart';
import 'keranjang.dart';
import 'product_model.dart';
import 'api_service.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  late Future<List<Product>> _productsFuture;
  late Future<List<ProductModel>> _localProductsFuture; // Hive data
  String _selectedCurrency = 'USD'; // Default currency is USD

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final apiService = Provider.of<ApiService>(context, listen: false);

    setState(() {
      switch (_selectedCategory) {
        case 1:
          _productsFuture = apiService.fetchProductsByCategory(1);
          break;
        case 2:
          _productsFuture = apiService.fetchProductsByCategory(2);
          break;
        case 3:
          _productsFuture = apiService.fetchProductsByCategory(3);
          break;
        case 4:
          _productsFuture = apiService.fetchProductsByCategory(4);
          break;
        case 5:
          _productsFuture = apiService.fetchProductsByCategory(5);
          break;
        default:
          _productsFuture = apiService.fetchAllProducts();
          break;
      }

      // Load Hive data
      _localProductsFuture = Hive.box<ProductModel>('products').isEmpty
          ? Future.value([])
          : Future.value(Hive.box<ProductModel>('products').values.toList());
    });
  }

  // Function to convert the price based on the selected currency
  double convertPrice(double price, String currency) {
    switch (currency) {
      case 'IDR':
        return price * 16000; // 1 USD = 16,000 IDR
      case 'JPY':
        return price * 150; // Example: 1 USD = 150 JPY
      case 'RUB':
        return price * 75; // Example: 1 USD = 75 RUB
      case 'GBP':
        return price * 0.83; // Example: 1 USD = 0.83 GBP
      default:
        return price; // Return the original price for USD
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              title: const Text(
                'YARD Sale',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              actions: [
                // Dropdown untuk memilih mata uang
                DropdownButton<String>(
                  value: _selectedCurrency,
                  items: const [
                    DropdownMenuItem(
                      value: 'USD',
                      child: Text('USD'),
                    ),
                    DropdownMenuItem(
                      value: 'IDR',
                      child: Text('IDR'),
                    ),
                    DropdownMenuItem(
                      value: 'JPY',
                      child: Text('JPY'),
                    ),
                    DropdownMenuItem(
                      value: 'RUB',
                      child: Text('RUB'),
                    ),
                    DropdownMenuItem(
                      value: 'GBP',
                      child: Text('GBP'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCurrency = newValue!;
                    });
                  },
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 10),
                // Ikon keranjang
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KeranjangScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.shopping_cart, color: Colors.white),
                ),
                const SizedBox(width: 10),
                // Ikon profile
                GestureDetector(
                  onTap: () {
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
                const SizedBox(width: 10),
              ],
              pinned: true,
              floating: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
              automaticallyImplyLeading: false,
            ),
          ];
        },
        body: Column(
          children: [
            _buildCategorySlider(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySlider() {
    return Column(
      children: [
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategoryCircle('All', 0),
              _buildCategoryCircle('Clothes', 1),
              _buildCategoryCircle('Electronic', 2),
              _buildCategoryCircle('Furniture', 3),
              _buildCategoryCircle('Shoes', 4),
              _buildCategoryCircle('Others', 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCircle(String title, int categoryIndex) {
    final isSelected = _selectedCategory == categoryIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = categoryIndex;
          _loadProducts();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
              radius: 30,
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> apiSnapshot) {
        if (apiSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (apiSnapshot.hasError) {
          return Center(child: Text('Error: ${apiSnapshot.error}'));
        } else if (!apiSnapshot.hasData || apiSnapshot.data!.isEmpty) {
          return const Center(child: Text('No products available'));
        } else {
          final apiProducts = apiSnapshot.data!;

          return FutureBuilder<List<ProductModel>>(
            future: _localProductsFuture,
            builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> hiveSnapshot) {
              if (hiveSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (hiveSnapshot.hasError) {
                return Center(child: Text('Error: ${hiveSnapshot.error}'));
              } else {
                final hiveProducts = hiveSnapshot.data ?? [];

                // Merge API and Hive products
                final allProducts = [...apiProducts, ...hiveProducts];

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: allProducts.length,
                  itemBuilder: (context, index) {
                    if (index >= apiProducts.length) {
                      return _buildProductCardHive(hiveProducts[index - apiProducts.length]);
                    } else {
                      return _buildProductCardApi(apiProducts[index]);
                    }
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  // Card to display Hive product
  Widget _buildProductCardHive(ProductModel product) {
    double convertedPrice = convertPrice(product.price, _selectedCurrency);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              product.imagePath,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  _selectedCurrency == 'USD'
                      ? '\$${product.price.toStringAsFixed(2)}'
                      : _selectedCurrency == 'IDR'
                          ? 'IDR ${convertedPrice.toStringAsFixed(2)}'
                          : _selectedCurrency == 'JPY'
                              ? '¥${convertedPrice.toStringAsFixed(2)}'
                              : _selectedCurrency == 'RUB'
                                  ? '₽${convertedPrice.toStringAsFixed(2)}'
                                  : '£${convertedPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.blue),
                ),
                const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Add product to cart logic
                      final hiveProvider = Provider.of<HiveProvider>(context, listen: false);
                      hiveProvider.addToCart(product as ProductModel);

                      // Show Snackbar indicating product added to cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add to Cart'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card to display API product
  Widget _buildProductCardApi(Product product) {
    double convertedPrice = convertPrice(product.price.toDouble(), _selectedCurrency);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailProdukScreen(product: product),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                product.images.isNotEmpty
                    ? product.images[0]
                    : 'https://via.placeholder.com/150',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  _selectedCurrency == 'USD'
                      ? '\$${product.price.toStringAsFixed(2)}'
                      : _selectedCurrency == 'IDR'
                          ? 'IDR ${convertedPrice.toStringAsFixed(2)}'
                          : _selectedCurrency == 'JPY'
                              ? '¥${convertedPrice.toStringAsFixed(2)}'
                              : _selectedCurrency == 'RUB'
                                  ? '₽${convertedPrice.toStringAsFixed(2)}'
                                  : '£${convertedPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.blue),
                ),
                const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Add product to cart logic
                      final cartProvider = Provider.of<CartProvider>(context, listen: false);
                      cartProvider.addToCart(product);

                      // Show Snackbar indicating product added to cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add to Cart'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
