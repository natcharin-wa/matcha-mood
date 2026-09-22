import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../controllers/cart_controller.dart';
import '../services/firestore_service.dart';
import 'receipt_page.dart';

// ยืนยันรายการสั่งซื้อ
class ConfirmOrderPage extends StatelessWidget {
  // ข้อมูลลูกค้าและรายการที่สั่ง
  final String name;
  final String phone;
  final String orderType;
  final int? tableNumber;
  final List<CartItem> items;
  final int totalPrice;

  const ConfirmOrderPage({
    super.key,
    required this.name,
    required this.phone,
    required this.orderType,
    this.tableNumber,
    required this.items,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ยืนยันการสั่งซื้อ')),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // ข้อมูลลูกค้า
            Text('ชื่อ: $name'),
            Text('เบอร์โทร: $phone'),
            Text('ประเภทการสั่ง: $orderType'),

            // แสดงโต๊ะเฉพาะตอนทานที่ร้าน
            if (tableNumber != null) Text('โต๊ะ: $tableNumber'),

            const SizedBox(height: 20),

            // หัวข้อรายการสินค้า
            const Text(
              'รายการสินค้า',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // แสดงรายการเครื่องดื่มที่อยู่ในตะกร้า
            ...items.map((item) {
              return ListTile(
                // ชื่อเครื่องดื่ม
                title: Text(item.product.name),

                // รายละเอียดที่ลูกค้าเลือก
                subtitle: Text(
                  'หวาน ${item.sweetness}% • ${item.drinkType}\n'
                  'ท็อปปิ้ง: ${item.toppings.isEmpty ? 'ไม่มี' : item.toppings.join(', ')}\n'
                  'เพิ่มเติม: ${item.extras.isEmpty ? 'ไม่มี' : item.extras.join(', ')}',
                ),

                // คำนวณราคาของรายการนี้
                trailing: Text(
                  '${(item.product.price + item.toppingPrice + item.extraPrice) * item.quantity} บาท',
                ),
              );
            }),

            const Divider(),

            // แสดงราคารวมทั้งหมด
            Text(
              'รวม $totalPrice บาท',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // ยืนยันออเดอร์
            ElevatedButton(
              onPressed: () async {
                // บันทึกข้อมูลออเดอร์ลง Firebase
                await FirestoreService().addOrder({
                  'name': name,
                  'phone': phone,
                  'orderType': orderType,
                  'tableNumber': tableNumber,
                  'totalPrice': totalPrice,

                  // สถานะเริ่มต้นของออเดอร์
                  'status': 'กำลังรับออเดอร์',

                  // บันทึกรายละเอียดสินค้าทั้งหมด
                  'items': items.map((item) {
                    return {
                      'product': item.product.name,
                      'quantity': item.quantity,
                      'sweetness': item.sweetness,
                      'drinkType': item.drinkType,
                      'iceLevel': item.iceLevel,
                      'toppings': item.toppings,
                      'extras': item.extras,
                      'toppingPrice': item.toppingPrice,
                      'extraPrice': item.extraPrice,
                    };
                  }).toList(),
                });

                // ตรวจสอบว่ายังอยู่ในหน้านี้ก่อนใช้ context
                if (!context.mounted) return;

                // สั่งซื้อเสร็จแล้วจึงล้างตะกร้า
                context.read<CartController>().clearCart();

                // ไปหน้าใบเสร็จ
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ReceiptPage(name: name, totalPrice: totalPrice),
                  ),
                );
              },
              child: const Text('ยืนยันการสั่งซื้อ'),
            ),
          ],
        ),
      ),
    );
  }
}
