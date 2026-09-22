import 'package:flutter/material.dart';

// แสดงใบเสร็จหลังสั่งซื้อ
class ReceiptPage extends StatelessWidget {
  final String name;
  final int totalPrice;

  const ReceiptPage({super.key, required this.name, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ใบเสร็จ')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // แสดงว่าสั่งซื้อสำเร็จ
            const Text('สั่งซื้อสำเร็จ!', style: TextStyle(fontSize: 24)),

            const SizedBox(height: 15),

            // แสดงชื่อลูกค้า
            Text('คุณ $name'),

            // แสดงยอดรวม
            Text('ยอดรวม $totalPrice บาท'),
          ],
        ),
      ),
    );
  }
}
