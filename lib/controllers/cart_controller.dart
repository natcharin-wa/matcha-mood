import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

// จัดการตะกร้าสินค้า
class CartController extends ChangeNotifier {
  List<CartItem> items = [];

  // เพิ่มสินค้า
  void addItem(CartItem item) {
    items.add(item);
    notifyListeners();
  }

  // ลดจำนวนสินค้า
  void decreaseItem(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      items.remove(item);
    }

    notifyListeners();
  }

  // หาราคารวม
  int get totalPrice {
    int total = 0;

    for (var item in items) {
      total +=
          (item.product.price + item.toppingPrice + item.extraPrice) *
          item.quantity;
    }

    return total;
  }

  // ลบสินค้า
  void removeItem(CartItem item) {
    items.remove(item);
    notifyListeners();
  }

  // ล้างตะกร้า
  void clearCart() {
    items.clear();
    notifyListeners();
  }
}
