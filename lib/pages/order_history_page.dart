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
          // รอข้อมูลจาก Firebase
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          // ถ้ายังไม่มีออเดอร์
          if (orders.isEmpty) {
            return const Center(child: Text('ยังไม่มีประวัติการสั่งซื้อ'));
          }

          // แสดงรายการออเดอร์
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              // ถ้าออเดอร์เก่าไม่มี status ให้ใช้ค่าเริ่มต้น
              final status = data['status'] ?? 'กำลังรับออเดอร์';

              return ListTile(
                title: Text(data['name']),
                subtitle: Text(
                  'ประเภท: ${data['orderType']}\n'
                  'ยอดรวม: ${data['totalPrice']} บาท\n'
                  'สถานะ: $status',
                ),

                // เปลี่ยนสถานะออเดอร์
                trailing: PopupMenuButton<String>(
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
              );
            },
          );
        },
      ),
    );
  }
}
