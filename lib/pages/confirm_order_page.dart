import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';
import 'receipt_page.dart';
import '../services/firestore_service.dart';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';

// หน้ายืนยันรายการสั่งซื้อ
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
            if (tableNumber != null) Text('โต๊ะ: $tableNumber'),

            const SizedBox(height: 20),

            const Text(
              'รายการสินค้า',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // รายการเครื่องดื่ม
            ...items.map((item) {
              return ListTile(
                title: Text(item.product.name),
                subtitle: Text(
                  'หวาน ${item.sweetness}% • ${item.drinkType}\n'
                  'ท็อปปิ้ง: ${item.toppings.isEmpty ? 'ไม่มี' : item.toppings.join(', ')}',
                ),
                trailing: Text(
                  '${(item.product.price + item.toppingPrice + item.extraPrice) * item.quantity} บาท',
                ),
              );
            }),

            const Divider(),

            // ราคารวม
            Text(
              'รวม $totalPrice บาท',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // ยืนยันออเดอร์
            ElevatedButton(
              onPressed: () async {
                // บันทึกออเดอร์ลง Firebase
                await FirestoreService().addOrder({
                  'testVersion': 'new_code',
                  'name': name,
                  'phone': phone,
                  'orderType': orderType,
                  'tableNumber': tableNumber,
                  'totalPrice': totalPrice,
                  'status': 'กำลังรับออเดอร์',

                  // รายละเอียดสินค้า
                  'items': items.map((item) {
                    return {
                      'product': item.product.name,
                      'quantity': item.quantity,
                      'sweetness': item.sweetness,
                      'drinkType': item.drinkType,
                      'iceLevel': item.iceLevel,
                      'toppings': item.toppings,
                      'toppingPrice': item.toppingPrice,
                      'extraPrice': item.extraPrice,
                    };
                  }).toList(),
                });

                if (!context.mounted) return;

                // ล้างตะกร้า
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
