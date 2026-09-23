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
    // โทนสีของหน้า Confirm
    const matchaGreen = Color(0xFF557C2B);
    const bgCream = Color(0xFFFAF5EF);
    const darkText = Color(0xFF2C3E1F);

    return Scaffold(
      backgroundColor: bgCream,

      appBar: AppBar(
        backgroundColor: matchaGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'ยืนยันการสั่งซื้อ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // การ์ดแสดงข้อมูลลูกค้า
            Card(
              color: Colors.white,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // หัวข้อข้อมูลลูกค้า
                    const Row(
                      children: [
                        Icon(Icons.person_pin, color: matchaGreen),
                        SizedBox(width: 8),
                        Text(
                          'ข้อมูลลูกค้า',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 20),

                    // แสดงข้อมูลลูกค้า
                    Text(
                      'ชื่อ: $name',
                      style: const TextStyle(fontSize: 15, color: darkText),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      'เบอร์โทร: $phone',
                      style: const TextStyle(fontSize: 15, color: darkText),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      'ประเภทการสั่ง: $orderType',
                      style: const TextStyle(fontSize: 15, color: darkText),
                    ),

                    // แสดงโต๊ะเฉพาะตอนทานที่ร้าน
                    if (tableNumber != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'โต๊ะ: $tableNumber',
                        style: const TextStyle(fontSize: 15, color: darkText),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // หัวข้อรายการสินค้า
            const Text(
              'รายการสินค้า',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),

            const SizedBox(height: 10),

            // แสดงรายการเครื่องดื่มที่อยู่ในตะกร้า
            ...items.map((item) {
              return Card(
                color: Colors.white,
                elevation: 0.5,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),

                  // ชื่อเครื่องดื่ม
                  title: Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  // รายละเอียดที่ลูกค้าเลือก
                  subtitle: Text(
                    'หวาน ${item.sweetness}% • ${item.drinkType}\n'
                    'ท็อปปิ้ง: '
                    '${item.toppings.isEmpty ? 'ไม่มี' : item.toppings.join(', ')}\n'
                    'เพิ่มเติม: '
                    '${item.extras.isEmpty ? 'ไม่มี' : item.extras.join(', ')}',
                    style: TextStyle(color: darkText.withValues(alpha: 0.7)),
                  ),

                  // คำนวณราคาของรายการนี้
                  trailing: Text(
                    '${(item.product.price + item.toppingPrice + item.extraPrice) * item.quantity} บาท',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: matchaGreen,
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 10),

            // กล่องสรุปราคารวมทั้งหมด
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: matchaGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ราคารวมทั้งหมด',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  Text(
                    'รวม $totalPrice บาท',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: matchaGreen,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ปุ่มยืนยันออเดอร์
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: matchaGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
                child: const Text(
                  'ยืนยันการสั่งซื้อ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
