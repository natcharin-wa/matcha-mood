import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

// หน้าประวัติการสั่งซื้อ
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

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
          'ประวัติการสั่งซื้อ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // ดึงข้อมูลออเดอร์จาก Firebase แบบ realtime
      body: StreamBuilder(
        stream: FirestoreService().getOrders(),
        builder: (context, snapshot) {
          // ระหว่างรอข้อมูลจาก Firebase
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: matchaGreen),
            );
          }

          // เก็บรายการออเดอร์ที่ได้จาก Firebase
          final orders = snapshot.data!.docs;

          // ถ้ายังไม่มีออเดอร์
          if (orders.isEmpty) {
            return const Center(
              child: Text(
                'ยังไม่มีประวัติการสั่งซื้อ',
                style: TextStyle(
                  fontSize: 16,
                  color: darkText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          // แสดงออเดอร์แต่ละรายการ
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              // ข้อมูลของออเดอร์แต่ละรายการ
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              // ถ้าออเดอร์ไม่มี status ให้ใช้สถานะเริ่มต้น
              final status = data['status'] ?? 'กำลังรับออเดอร์';

              return Card(
                color: Colors.white,
                elevation: 0.5,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),

                  // แสดงชื่อลูกค้า
                  title: Text(
                    data['name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: darkText,
                    ),
                  ),

                  // แสดงข้อมูลของออเดอร์
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'ประเภท: ${data['orderType']}\n'
                      'ยอดรวม: ${data['totalPrice']} บาท\n'
                      'สถานะ: $status',
                      style: TextStyle(
                        color: darkText.withValues(alpha: 0.75),
                        height: 1.3,
                      ),
                    ),
                  ),

                  // ปุ่มเปลี่ยนสถานะและลบออเดอร์
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // เลือกสถานะของออเดอร์
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.edit_note, color: matchaGreen),
                        onSelected: (status) async {
                          await FirestoreService().updateOrder(
                            order.id,
                            status,
                          );
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'กำลังรับออเดอร์',
                              child: Text('กำลังรับออเดอร์'),
                            ),
                            const PopupMenuItem(
                              value: 'กำลังเตรียม',
                              child: Text('กำลังเตรียม'),
                            ),
                            const PopupMenuItem(
                              value: 'เสร็จแล้ว',
                              child: Text('เสร็จแล้ว'),
                            ),
                          ];
                        },
                      ),

                      // ลบออเดอร์
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () async {
                          await FirestoreService().deleteOrder(order.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
