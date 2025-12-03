import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  String image; // url ou asset

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  // Pour Firebase conversion si besoin
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    final rawPrice = map['price'];
    double parsedPrice;

    if (rawPrice == null) {
      parsedPrice = 0;
    } else if (rawPrice is num) {
      parsedPrice = rawPrice.toDouble();
    } else if (rawPrice is String && rawPrice.isNotEmpty) {
      parsedPrice = double.tryParse(rawPrice) ?? 0;
    } else {
      parsedPrice = 0;
    }

    return Product(
      id: id,
      name: map['name'] ?? '',
      price: parsedPrice,
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'price': price,
    'image': image,
  };
}
