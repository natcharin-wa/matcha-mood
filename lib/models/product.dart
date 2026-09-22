// เก็บข้อมูลสินค้าแต่ละรายการ
class Product {
  // รหัสสินค้าจาก Firebase
  String? id;

  // ชื่อสินค้า
  String name;

  // ราคาสินค้า
  int price;

  // Constructor ใช้รับชื่อ ราคา และรหัสสินค้า
  Product(this.name, this.price, {this.id});
}
