import 'package:flutter/material.dart';
import '../data/menu_data.dart';
import 'cart_page.dart';
import 'customize_page.dart';
import 'order_history_page.dart';
import 'api_page.dart';

// หน้าแสดงเมนู
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matcha Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.api),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ApiPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
              );
            },
          ),
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

      // แสดงรายการเมนูทั้งหมด
      body: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (context, index) {
          final product = menu[index];

          return ListTile(
            title: Text(product.name),
            subtitle: Text('${product.price} บาท'),
            // ไปหน้าปรับแต่งเมนู
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
