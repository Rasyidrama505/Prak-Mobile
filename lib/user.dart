import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;

  User({required this.username, required this.password});
}

@HiveType(typeId: 1) 
class ProductModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double price;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String imagePath;

  ProductModel({
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });
}