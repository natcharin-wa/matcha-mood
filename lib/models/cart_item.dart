import 'product.dart';

// เก็บรายละเอียดเครื่องดื่มในตะกร้า
class CartItem {
  Product product;
  int quantity;
  int sweetness;
  String drinkType;
  String iceLevel;
  List<String> toppings;
  int toppingPrice;
  int extraPrice;

  CartItem(
    this.product,
    this.quantity,
    this.sweetness,
    this.drinkType,
    this.iceLevel,
    this.toppings,
    this.toppingPrice,
    this.extraPrice,
  );
}
