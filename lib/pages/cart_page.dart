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

    // โทนสีของหน้า Cart
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
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [
          // แสดงรายการสินค้าในตะกร้า
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                // ดึงสินค้าแต่ละรายการจากตะกร้า
                final item = cart.items[index];

                return Card(
                  color: Colors.white,
                  elevation: 0.5,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    // ชื่อเครื่องดื่ม
                    title: Text(
                      item.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkText,
                        fontSize: 16,
                      ),
                    ),

                    // แสดงรายละเอียดของเครื่องดื่ม
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${item.product.price} บาท • '
                        'หวาน ${item.sweetness}% • '
                        '${item.drinkType} • '
                        'น้ำแข็ง${item.iceLevel}\n'
                        'ท็อปปิ้ง: '
                        '${item.toppings.isEmpty ? 'ไม่มี' : item.toppings.join(', ')}\n'
                        'เพิ่มเติม: '
                        '${item.extras.isEmpty ? 'ไม่มี' : item.extras.join(', ')}',
                        style: TextStyle(
                          color: darkText.withValues(alpha: 0.7),
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ),

                    // ปุ่มจัดการจำนวนสินค้า
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ลดจำนวนสินค้า
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            cart.decreaseItem(item);
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: matchaGreen,
                            size: 22,
                          ),
                        ),

                        // แสดงจำนวนสินค้า
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: darkText,
                            ),
                          ),
                        ),

                        // เพิ่มจำนวนสินค้า
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            cart.increaseItem(item);
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: matchaGreen,
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 6),

                        // ลบสินค้าออกจากตะกร้า
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            cart.removeItem(item);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // แถบสรุปราคารวมด้านล่าง
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // แสดงราคารวมทั้งหมด
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'รวมทั้งหมด',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                      Text(
                        '${cart.totalPrice} บาท',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: matchaGreen,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // ไปหน้ากรอกข้อมูลลูกค้า
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: matchaGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomerInfoPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'ดำเนินการสั่งซื้อ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
