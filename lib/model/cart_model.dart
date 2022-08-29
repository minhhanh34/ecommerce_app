class CartModel {
  String imageURL;
  String name;
  int price;
  int saleOff;
  int quantity;
  bool isFavorite;
  String color;
  int rom;
  int ram;
  CartModel({
    required this.imageURL,
    required this.name,
    required this.price,
    this.saleOff = 0,
    this.quantity = 1,
    this.isFavorite = false,
    required this.color,
    required this.rom,
    required this.ram,
  });
}
