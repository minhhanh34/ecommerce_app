class ProductModel {
  String name;
  Map<String, dynamic> imageUrls;
  int price;
  int grade;
  int sold;
  bool isFavorite;
  ProductModel({
    required this.name,
    required this.imageUrls,
    required this.price,
    this.grade = 0,
    this.sold = 0,
    this.isFavorite = false,
  });
}
