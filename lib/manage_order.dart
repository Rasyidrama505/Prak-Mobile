import 'package:flutter/material.dart';
import 'package:online_shop/checkout_model.dart';

class ManageOrder with ChangeNotifier {
  final List<CheckoutSession> _checkoutHistory = [
    CheckoutSession(
      id: 1,
      checkoutTime: DateTime.now(),
      productNames: ['Product A', 'Product B'],
      totalPrice: 200.0,
    ),
    CheckoutSession(
      id: 2,
      checkoutTime: DateTime.now().subtract(Duration(days: 1)),
      productNames: ['Product C'],
      totalPrice: 100.0,
    ),
    CheckoutSession(
      id: 3,
      checkoutTime: DateTime.now().subtract(Duration(days: 2)),
      productNames: ['Product D', 'Product E'],
      totalPrice: 300.0,
    ),
  ];

  List<CheckoutSession> get checkoutHistory => _checkoutHistory;

  void confirmOrder(int id) {
    final session = _checkoutHistory.firstWhere((s) => s.id == id);
    session.status = 'Pesanan Dikonfirmasi';
    notifyListeners();
  }
}
