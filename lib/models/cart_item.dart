import 'product.dart';

// เก็บรายละเอียดเครื่องดื่มแต่ละรายการในตะกร้า
class CartItem {
  // ข้อมูลสินค้า
  Product product;

  // จำนวนสินค้าที่สั่ง
  int quantity;

  // ระดับความหวาน
  int sweetness;

  // ประเภทเครื่องดื่ม เย็นหรือปั่น
  String drinkType;

  // ระดับน้ำแข็ง
  String iceLevel;

  // รายการท็อปปิ้งที่เลือก
  List<String> toppings;

  // รายการของเพิ่มเติมที่เลือก
  List<String> extras;

  // ราคารวมท็อปปิ้ง
  int toppingPrice;

  // ราคารวมของของเพิ่มเติม รวมค่าปั่นด้วย
  int extraPrice;

  // Constructor ใช้รับข้อมูลทั้งหมดของเครื่องดื่ม
  CartItem(
    this.product,
    this.quantity,
    this.sweetness,
    this.drinkType,
    this.iceLevel,
    this.toppings,
    this.extras,
    this.toppingPrice,
    this.extraPrice,
  );
}
