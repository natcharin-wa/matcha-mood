import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

// จัดการข้อมูลใน Firestore
class FirestoreService {
  // เชื่อมต่อกับ Firebase
  final db = FirebaseFirestore.instance;

  // เพิ่มสินค้า
  Future<void> addProduct(String name, int price) {
    return db.collection('products').add({'name': name, 'price': price});
  }

  // เพิ่มสินค้าหลายรายการ
  Future<void> addProducts(List<Product> products) async {
    for (var product in products) {
      await addProduct(product.name, product.price);
    }
  }

  // ดึงข้อมูลสินค้าจาก Firebase
  Stream<QuerySnapshot> getProducts() {
    return db.collection('products').snapshots();
  }

  // แก้ไขข้อมูลสินค้า
  Future<void> updateProduct(String id, String name, int price) {
    return db.collection('products').doc(id).update({
      'name': name,
      'price': price,
    });
  }

  // ลบสินค้า
  Future<void> deleteProduct(String id) {
    return db.collection('products').doc(id).delete();
  }

  // เพิ่มออเดอร์
  Future<void> addOrder(Map<String, dynamic> order) {
    return db.collection('orders').add(order);
  }

  // ดึงประวัติออเดอร์
  Stream<QuerySnapshot> getOrders() {
    return db.collection('orders').snapshots();
  }

  // ลบออเดอร์
  Future<void> deleteOrder(String id) {
    return db.collection('orders').doc(id).delete();
  }

  // เปลี่ยนสถานะออเดอร์
  Future<void> updateOrder(String id, String status) {
    return db.collection('orders').doc(id).update({'status': status});
  }
}
