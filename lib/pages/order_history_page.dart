import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

// หน้าประวัติการสั่งซื้อ
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ประวัติการสั่งซื้อ')),

      // ดึงข้อมูลออเดอร์จาก Firebase แบบ realtime
      body: StreamBuilder(
        stream: FirestoreService().getOrders(),
        builder: (context, snapshot) {
          // ระหว่างรอข้อมูลจาก Firebase
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // เก็บรายการออเดอร์ที่ได้จาก Firebase
          final orders = snapshot.data!.docs;

          // ถ้ายังไม่มีออเดอร์
          if (orders.isEmpty) {
            return const Center(child: Text('ยังไม่มีประวัติการสั่งซื้อ'));
          }

          // แสดงออเดอร์แต่ละรายการ
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              // ข้อมูลของออเดอร์แต่ละรายการ
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              // ถ้าออเดอร์ไม่มี status ให้ใช้สถานะเริ่มต้น
              final status = data['status'] ?? 'กำลังรับออเดอร์';

              return ListTile(
                // แสดงชื่อลูกค้า
                title: Text(data['name']),

                // แสดงข้อมูลของออเดอร์
                subtitle: Text(
                  'ประเภท: ${data['orderType']}\n'
                  'ยอดรวม: ${data['totalPrice']} บาท\n'
                  'สถานะ: $status',
                ),

                // ปุ่มเปลี่ยนสถานะและลบออเดอร์
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // เลือกสถานะของออเดอร์
                    PopupMenuButton<String>(
                      onSelected: (status) async {
                        await FirestoreService().updateOrder(order.id, status);
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
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await FirestoreService().deleteOrder(order.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
