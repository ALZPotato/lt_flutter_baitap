class Food {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;

  Food({required this.id, required this.name, required this.price, required this.image, required this.category});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image'],
      category: json['category'],
    );
  }
}