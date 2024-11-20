import 'package:flutter/material.dart';
import 'checkout_model.dart';

class CheckoutProvider with ChangeNotifier {
  List<CheckoutSession> _checkoutHistory = [];
  int _sessionId = 0;

  List<CheckoutSession> get checkoutHistory => _checkoutHistory;

  void addCheckoutSession(List<String> productNames, double totalPrice) {
    _sessionId++;
    _checkoutHistory.add(CheckoutSession(
      id: _sessionId,
      checkoutTime: DateTime.now(),
      productNames: productNames,
      totalPrice: totalPrice,
    ));
    notifyListeners();
  }

  /// Metode untuk memperbarui status pesanan
  void updateStatus(int id, String newStatus) {
    final session = _checkoutHistory.firstWhere((session) => session.id == id);
    session.status = newStatus; // Update status
    notifyListeners(); // Memberitahu UI agar diperbarui
  }
}
