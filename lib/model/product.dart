class Product {
  final int id;
  final String name;
  final double price;
  final DateTime dateAdded;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.dateAdded,
    required this.isAvailable,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      dateAdded: DateTime.parse(json['dateAdded']),
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'dateAdded': dateAdded.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }
}
