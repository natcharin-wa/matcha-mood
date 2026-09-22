import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

// Controller สำหรับจัดการข้อมูลในตะกร้าสินค้า
class CartController extends ChangeNotifier {
  // เก็บรายการสินค้าทั้งหมดในตะกร้า
  List<CartItem> items = [];

  // เพิ่มสินค้าใหม่ลงในตะกร้า
  void addItem(CartItem item) {
    items.add(item);

    // แจ้งหน้า UI ให้แสดงข้อมูลใหม่
    notifyListeners();
  }

  // เพิ่มจำนวนสินค้าที่เลือก
  void increaseItem(CartItem item) {
    item.quantity++;

    // แจ้งให้หน้า Cart อัปเดตจำนวน
    notifyListeners();
  }

  // ลดจำนวนสินค้า
  void decreaseItem(CartItem item) {
    if (item.quantity > 1) {
      // ถ้ามากกว่า 1 ให้ลดจำนวน
      item.quantity--;
    } else {
      // ถ้าเหลือ 1 แล้วกดลด ให้ลบรายการออก
      items.remove(item);
    }

    // แจ้งให้หน้า UI อัปเดต
    notifyListeners();
  }

  // คำนวณราคารวมของสินค้าทั้งหมด
  int get totalPrice {
    int total = 0;

    // วนดูสินค้าทุกชิ้นในตะกร้า
    for (var item in items) {
      // ราคาสินค้า + ท็อปปิ้ง + ของเพิ่มเติม แล้วคูณจำนวน
      total +=
          (item.product.price + item.toppingPrice + item.extraPrice) *
          item.quantity;
    }

    return total;
  }

  // ลบสินค้ารายการที่เลือกออกจากตะกร้า
  void removeItem(CartItem item) {
    items.remove(item);

    // แจ้งให้หน้า UI อัปเดต
    notifyListeners();
  }

  // ล้างสินค้าทั้งหมดออกจากตะกร้า
  void clearCart() {
    items.clear();

    // แจ้งให้หน้า UI อัปเดต
    notifyListeners();
  }
}
