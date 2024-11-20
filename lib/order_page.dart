import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkout_provider.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Pesanan'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: checkoutProvider.checkoutHistory.isEmpty
          ? const Center(
              child: Text(
                'Belum ada pesanan.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: checkoutProvider.checkoutHistory.length,
              itemBuilder: (context, index) {
                final session = checkoutProvider.checkoutHistory[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pesanan #${session.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Produk: ${session.productNames.join(', ')}'),
                        Text(
                          'Waktu Checkout: ${session.checkoutTime.toLocal()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Total Harga: \$${session.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Status: ${session.status}'),
                        const SizedBox(height: 10),
                        // Kondisi untuk menampilkan tombol Confirm hanya jika status belum "Berhasil Dipesan"
                        if (session.status != 'Berhasil Dipesan')
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                checkoutProvider.updateStatus(
                                    session.id, 'Berhasil Dipesan');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Pesanan #${session.id} dikonfirmasi!',
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Confirm',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
