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

  // ลิงก์รูปภาพของแต่ละเมนู
  static const Map<String, String> menuImages = {
    'Original Matcha':
        'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=300',
    'Matcha Latte':
        'https://images.unsplash.com/photo-1515823662972-da6a2e4d3002?w=300',
    'Sea Salt Cream Matcha':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7BRu9yfZpGN_3WwtEa0QN0lyt-YdSsctu20LGdqjWpQ&s=10',
    'Caramel Matcha':
        'https://tenzotea.co/cdn/shop/articles/Caramel_Matcha.png?v=1723483761&width=1000',
    'Oreo Matcha':
        'https://paragontearoom.com/cdn/shop/articles/9dc623287b4693c0184bd533d05ea9f9.png?v=1737164213&width=1100',
    'Taro Matcha':
        'https://tenzotea.co/cdn/shop/articles/Taro_Matcha_NEW.png?v=1721235193&width=1000',
    'Banana Matcha':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTopL7eZTC_RZXS08gMd91dQ1HkqKFb5fghfvWpW_OZaxpkAa6RCLFNmD8&s=10',
    'Strawberry Matcha':
        'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=300',
    'Mango Matcha':
        'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=300',
    'Biscoff Cream Matcha':
        'https://matcha.com/cdn/shop/articles/matchaonomu_-_biscoff_crunch_cream_matcha_latte_2.jpg?v=1770675639',
  };

  // รูปสำรองกรณีโหลดรูปไม่สำเร็จ
  static const defaultImage =
      'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=300';

  @override
  Widget build(BuildContext context) {
    // โทนสีของหน้า
    const matchaGreen = Color(0xFF557C2B);
    const accentPink = Color(0xFFEFB7F7);
    const bgCream = Color(0xFFFAF5EF);
    const darkText = Color(0xFF2C3E1F);

    return Scaffold(
      backgroundColor: bgCream,

      appBar: AppBar(
        backgroundColor: matchaGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Matcha Mood',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

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

      // แสดงรายการเมนูทั้งหมด
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // หัวข้อรายการเมนู
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'รายการเมนู',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                Text(
                  '${menu.length} รายการ',
                  style: TextStyle(
                    fontSize: 13,
                    color: darkText.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // รายการสินค้า
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              itemCount: menu.length,
              itemBuilder: (context, index) {
                // ดึงเมนูตามลำดับที่กำลังแสดง
                final product = menu[index];

                // ดึงรูปตามชื่อเมนู
                final imageUrl = menuImages[product.name] ?? defaultImage;

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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    // รูปภาพเมนู
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,

                        // แสดง Loading ระหว่างโหลดรูป
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return Container(
                            width: 55,
                            height: 55,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: matchaGreen,
                                ),
                              ),
                            ),
                          );
                        },

                        // ถ้ารูปโหลดไม่ได้ ใช้ไอคอนแทน
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 55,
                            height: 55,
                            color: accentPink.withValues(alpha: 0.3),
                            child: const Icon(
                              Icons.local_cafe,
                              color: matchaGreen,
                            ),
                          );
                        },
                      ),
                    ),

                    // ชื่อเมนู
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkText,
                        fontSize: 16,
                      ),
                    ),

                    // ราคาเมนู
                    subtitle: Text(
                      '${product.price} บาท',
                      style: TextStyle(
                        color: darkText.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // ปุ่มเพิ่มเพื่อไปหน้าปรับแต่ง
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentPink,
                        foregroundColor: darkText,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomizePage(product: product),
                          ),
                        );
                      },
                      child: const Text(
                        'เพิ่ม',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
