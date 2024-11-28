import 'package:flutter/material.dart';
import 'package:online_shop/user.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'product_model.dart';
import 'api_service.dart';
import 'add_product.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedCategory = 0;
  late Future<List<Product>> _productsFuture;
  late Future<List<ProductModel>> _localProductsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final productsBox = Hive.box<ProductModel>('products');

    setState(() {
      if (_selectedCategory == 0) {
        _productsFuture = apiService.fetchAllProducts();
      } else {
        _productsFuture = apiService.fetchProductsByCategory(_selectedCategory);
      }
      _localProductsFuture = Future.value(
          productsBox.values.isNotEmpty ? productsBox.values.toList() : []);
    });
  }

  void _deleteProductFromHive(int index) async {
  final box = Hive.box<ProductModel>('products');
  if (index < box.length) {
    await box.deleteAt(index);

    setState(() {
      _localProductsFuture = Future.value(box.values.toList());
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Produk berhasil dihapus!')),
    );

    print('Product deleted successfully');
  } else {
    print('Index out of range: $index');
  }
}

  Future<void> _deleteProductFromApi(int productId) async {
  try {
    final apiService = Provider.of<ApiService>(context, listen: false);
    await apiService.deleteProduct(productId); // Fungsi ini harus sudah diimplementasikan di ApiService
    
    // Refresh data setelah penghapusan
    _loadProducts();

    // Tampilkan notifikasi berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Produk berhasil dihapus dari server!')),
    );
  } catch (error) {
    // Tampilkan notifikasi error jika ada masalah
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menghapus produk: $error')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Admin"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddProduct()),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String title, int categoryIndex) {
    final isSelected = _selectedCategory == categoryIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = categoryIndex;
          _loadProducts();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Chip(
          label: Text(title),
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> apiSnapshot) {
        if (apiSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (apiSnapshot.hasError) {
          return Center(child: Text('Error: ${apiSnapshot.error}'));
        } else if (!apiSnapshot.hasData || apiSnapshot.data!.isEmpty) {
          return Center(child: Text('No products available'));
        } else {
          final apiProducts = apiSnapshot.data!;

          return FutureBuilder<List<ProductModel>>(
            future: _localProductsFuture,
            builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> hiveSnapshot) {
              if (hiveSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (hiveSnapshot.hasError) {
                return Center(child: Text('Error: ${hiveSnapshot.error}'));
              } else {
                final hiveProducts = hiveSnapshot.data ?? [];
                final allProducts = [...apiProducts, ...hiveProducts];

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: allProducts.length,
                  itemBuilder: (context, index) {
                    if (index >= apiProducts.length) {
                      return _buildProductCardHive(
                          hiveProducts[index - apiProducts.length], index - apiProducts.length);
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

  Widget _buildProductCardHive(ProductModel product, int index) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
            child: Image.network(
              product.imagePath.isNotEmpty
                  ? product.imagePath
                  : 'https://via.placeholder.com/150',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _deleteProductFromHive(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCardApi(Product product) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
            child: Image.network(
              product.images.isNotEmpty
                  ? product.images[0]
                  : 'https://via.placeholder.com/150',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _deleteProductFromApi(product.id);
            },
          ),
        ],
      ),
    );
  }
}
