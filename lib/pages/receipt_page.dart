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
    // โทนสีของหน้า
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
          'ใบเสร็จ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // จัดใบเสร็จให้อยู่กลางหน้า
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ไอคอนบอกว่าการสั่งซื้อสำเร็จ
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: matchaGreen.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: matchaGreen,
                      size: 64,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // แสดงข้อความเมื่อสั่งซื้อสำเร็จ
                  const Text(
                    'สั่งซื้อสำเร็จ!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // แสดงชื่อลูกค้า
                  Text(
                    'คุณ $name',
                    style: const TextStyle(
                      fontSize: 18,
                      color: darkText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // แสดงยอดรวมที่ต้องชำระ
                  Text(
                    'ยอดรวม $totalPrice บาท',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: matchaGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
