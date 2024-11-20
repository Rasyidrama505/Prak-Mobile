import 'package:flutter/material.dart';
import 'package:online_shop/checkout_provider.dart';
import 'package:online_shop/user.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'hive_provider.dart';
import 'product_model.dart';

class KeranjangScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access both providers
    final cart = Provider.of<CartProvider>(context);
    final hiveProvider = Provider.of<HiveProvider>(context);

    // Combine both lists into a single list
    final combinedCartItems = [
      ...cart.cartItems.map((product) => {
            'title': product.title,
            'price': product.price,
            'image': product.images.isNotEmpty ? product.images[0] : 'https://via.placeholder.com/150',
            'isFromCartProvider': true,
            'product': product,
          }),
      ...hiveProvider.cartItems.map((productModel) => {
            'title': productModel.name,
            'price': productModel.price,
            'image': productModel.imagePath.isNotEmpty ? productModel.imagePath : 'https://via.placeholder.com/150',
            'isFromCartProvider': false,
            'product': productModel,
          }),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: combinedCartItems.isEmpty
          ? const Center(child: Text('Keranjang Anda kosong'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: combinedCartItems.length,
                    itemBuilder: (context, index) {
                      final item = combinedCartItems[index];
                      final title = item['title'] as String;
                      final price = item['price'] as double;
                      final image = item['image'] as String;
                      final isFromCartProvider = item['isFromCartProvider'] as bool;
                      final product = item['product'];

                      return ListTile(
                        leading: Image.network(
                          image,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(title),
                        subtitle: Text('Price: \$${price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            if (isFromCartProvider) {
                              cart.removeFromCart(product as Product);
                            } else {
                              hiveProvider.removeFromCart(product as ProductModel);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$title removed from cart!')),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${(cart.totalPrice + hiveProvider.totalPrice).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final productNames = combinedCartItems.map((item) => item['title'] as String).toList();
                    final totalPrice = cart.totalPrice + hiveProvider.totalPrice;

                    // Save checkout session
                    Provider.of<CheckoutProvider>(context, listen: false).addCheckoutSession(productNames, totalPrice);

                    // Clear both carts
                    cart.clearCart();
                    hiveProvider.clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Checkout successful!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }
}
