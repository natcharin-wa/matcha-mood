import 'package:flutter/material.dart';

import '../data/menu_data.dart';
import 'profile_page.dart';
import 'cart_page.dart';
import 'customize_page.dart';
import 'order_history_page.dart';
import 'api_page.dart';

// แสดงเมนูหลัก
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matcha Menu'),

        // ปุ่มต่างๆ ด้านบนของหน้า
        actions: [
          // ไปหน้าโปรไฟล์สมาชิก
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),

          // ไปหน้าข้อมูลจาก API
          IconButton(
            icon: const Icon(Icons.api),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ApiPage()),
              );
            },
          ),

          // ไปหน้าประวัติการสั่งซื้อ
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
              );
            },
          ),

          // ไปหน้าตะกร้าสินค้า
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),

      // แสดงรายการเมนูจาก menu_data.dart
      body: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (context, index) {
          // ดึงเมนูตามลำดับที่กำลังแสดง
          final product = menu[index];

          return ListTile(
            // ชื่อเมนู
            title: Text(product.name),

            // ราคาเมนู
            subtitle: Text('${product.price} บาท'),

            // ปุ่มเพิ่มเพื่อไปหน้าปรับแต่งเครื่องดื่ม
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CustomizePage(product: product),
                  ),
                );
              },
              child: const Text('เพิ่ม'),
            ),
          );
        },
      ),
    );
  }
}
