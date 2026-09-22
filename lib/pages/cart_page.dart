import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/cart_controller.dart';
import 'customer_info_page.dart';

// หน้าตะกร้าสินค้า
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลตะกร้าจาก CartController
    // watch ทำให้หน้านี้อัปเดตเมื่อข้อมูลตะกร้าเปลี่ยน
    final cart = context.watch<CartController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),

      body: Column(
        children: [
          // แสดงรายการสินค้าในตะกร้า
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                // ดึงสินค้าแต่ละรายการจากตะกร้า
                final item = cart.items[index];

                return ListTile(
                  // ชื่อเครื่องดื่ม
                  title: Text(item.product.name),

                  // แสดงรายละเอียดของเครื่องดื่ม
                  subtitle: Text(
                    '${item.product.price} บาท • '
                    'หวาน ${item.sweetness}% • '
                    '${item.drinkType} • '
                    'น้ำแข็ง${item.iceLevel}\n'
                    'ท็อปปิ้ง: '
                    '${item.toppings.isEmpty ? 'ไม่มี' : item.toppings.join(', ')}\n'
                    'เพิ่มเติม: '
                    '${item.extras.isEmpty ? 'ไม่มี' : item.extras.join(', ')}',
                  ),

                  // ปุ่มจัดการจำนวนสินค้า
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ลดจำนวนสินค้า
                      IconButton(
                        onPressed: () {
                          cart.decreaseItem(item);
                        },
                        icon: const Icon(Icons.remove),
                      ),

                      // แสดงจำนวนสินค้า
                      Text('${item.quantity}'),

                      // เพิ่มจำนวนสินค้า
                      IconButton(
                        onPressed: () {
                          cart.increaseItem(item);
                        },
                        icon: const Icon(Icons.add),
                      ),

                      // ลบสินค้าออกจากตะกร้า
                      IconButton(
                        onPressed: () {
                          cart.removeItem(item);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // แสดงราคารวมทั้งหมด
          Text(
            'รวม ${cart.totalPrice} บาท',
            style: const TextStyle(fontSize: 20),
          ),

          const SizedBox(height: 15),

          // ไปหน้ากรอกข้อมูลลูกค้า
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerInfoPage()),
              );
            },
            child: const Text('ดำเนินการสั่งซื้อ'),
          ),
        ],
      ),
    );
  }
}
