import 'package:flutter/material.dart';

// แสดงใบเสร็จหลังจากสั่งซื้อ
class ReceiptPage extends StatelessWidget {
  // ชื่อลูกค้าที่ส่งมาจากหน้าก่อนหน้า
  final String name;

  // ยอดรวมออเดอร์
  final int totalPrice;

  // รับข้อมูลชื่อลูกค้าและยอดรวม
  const ReceiptPage({super.key, required this.name, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ชื่อหน้า
      appBar: AppBar(title: const Text('ใบเสร็จ')),

      // จัดให้อยู่กลางหน้า
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // แสดงข้อความเมื่อสั่งซื้อสำเร็จ
            const Text('สั่งซื้อสำเร็จ!', style: TextStyle(fontSize: 24)),

            const SizedBox(height: 15),

            // แสดงชื่อลูกค้า
            Text('คุณ $name'),

            // แสดงยอดรวมที่ต้องชำระ
            Text('ยอดรวม $totalPrice บาท'),
          ],
        ),
      ),
    );
  }
}
