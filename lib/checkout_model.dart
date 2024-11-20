class CheckoutSession {
  final int id;
  final DateTime checkoutTime;
  final List<String> productNames;
  final double totalPrice;
  String status; // Tambahkan status dengan nilai default

  CheckoutSession({
    required this.id,
    required this.checkoutTime,
    required this.productNames,
    required this.totalPrice,
    this.status = 'Dalam Proses', // Nilai default
  });
}
