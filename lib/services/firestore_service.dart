import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

// Service สำหรับจัดการข้อมูลที่อยู่ใน Firebase
class FirestoreService {
  // เชื่อมต่อกับฐานข้อมูล Firestore
  final db = FirebaseFirestore.instance;

  // เพิ่มสินค้า 1 รายการ
  // รับชื่อและราคาสินค้า แล้วบันทึกลง collection products
  Future<void> addProduct(String name, int price) {
    return db.collection('products').add({'name': name, 'price': price});
  }

  // เพิ่มสินค้าหลายรายการ
  // ใช้ตอนต้องการเพิ่มข้อมูลจาก List เข้า Firebase
  Future<void> addProducts(List<Product> products) async {
    for (var product in products) {
      await addProduct(product.name, product.price);
    }
  }

  // ดึงข้อมูลสินค้าจาก Firebase
  // ใช้ Stream เพื่อให้ข้อมูลอัปเดตเมื่อข้อมูลใน Firebase เปลี่ยน
  Stream<QuerySnapshot> getProducts() {
    return db.collection('products').snapshots();
  }

  // แก้ไขข้อมูลสินค้า
  // ใช้ id ของ document เพื่อเลือกสินค้าที่ต้องการแก้
  Future<void> updateProduct(String id, String name, int price) {
    return db.collection('products').doc(id).update({
      'name': name,
      'price': price,
    });
  }

  // ลบสินค้าออกจาก Firebase
  Future<void> deleteProduct(String id) {
    return db.collection('products').doc(id).delete();
  }

  // เพิ่มออเดอร์
  // รับข้อมูลออเดอร์มาเป็น Map แล้วบันทึกลง orders
  Future<void> addOrder(Map<String, dynamic> order) {
    return db.collection('orders').add(order);
  }

  // ดึงประวัติการสั่งซื้อแบบ realtime
  Stream<QuerySnapshot> getOrders() {
    return db.collection('orders').snapshots();
  }

  // ลบออเดอร์
  Future<void> deleteOrder(String id) {
    return db.collection('orders').doc(id).delete();
  }

  // เปลี่ยนสถานะของออเดอร์
  Future<void> updateOrder(String id, String status) {
    return db.collection('orders').doc(id).update({'status': status});
  }
}
