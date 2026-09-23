import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// แสดงข้อมูลสมาชิก
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // เก็บรูปสมาชิกแต่ละคน
  Uint8List? image1;
  Uint8List? image2;

  @override
  void initState() {
    super.initState();

    // โหลดรูปที่บันทึกไว้
    loadImages();
  }

  // โหลดรูปจาก SharedPreferences
  Future<void> loadImages() async {
    final prefs = await SharedPreferences.getInstance();

    // โหลดรูปสมาชิกคนที่ 1
    final savedImage1 = prefs.getString('image1');

    // โหลดรูปสมาชิกคนที่ 2
    final savedImage2 = prefs.getString('image2');

    setState(() {
      if (savedImage1 != null) {
        image1 = base64Decode(savedImage1);
      }

      if (savedImage2 != null) {
        image2 = base64Decode(savedImage2);
      }
    });
  }

  // เลือกรูปจากเครื่อง
  Future<void> pickImage(int member) async {
    // เปิดหน้าต่างให้เลือกรูปจาก Gallery
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    // ถ้าเลือกรูปแล้ว นำรูปมาใช้งาน
    if (picked != null) {
      // อ่านรูปเป็นข้อมูลแบบ bytes
      final bytes = await picked.readAsBytes();

      // แปลงรูปเพื่อใช้บันทึก
      final imageData = base64Encode(bytes);

      // เปิด SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // อัปเดตรูปที่แสดงบนหน้า
      setState(() {
        if (member == 1) {
          image1 = bytes;
        } else {
          image2 = bytes;
        }
      });

      // บันทึกรูปล่าสุด
      if (member == 1) {
        await prefs.setString('image1', imageData);
      } else {
        await prefs.setString('image2', imageData);
      }
    }
  }

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
          'สมาชิก',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // ใช้ ListView เพื่อให้หน้าเลื่อนดูสมาชิกได้
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // การ์ดสมาชิกคนที่ 1
          Card(
            color: Colors.white,
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // รูปสมาชิกคนที่ 1
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: matchaGreen.withValues(alpha: 0.12),
                    child: image1 == null
                        ? const Icon(Icons.person, size: 50, color: matchaGreen)
                        : ClipOval(
                            child: Image.memory(
                              image1!,
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),

                  const SizedBox(height: 12),

                  // ข้อมูลสมาชิกคนที่ 1
                  const Text(
                    'นางสาวธนิดา ดิษเทศ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '6721652242',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: darkText.withValues(alpha: 0.7),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ปุ่มเลือกรูปสมาชิกคนที่ 1
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: matchaGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () => pickImage(1),
                    icon: const Icon(Icons.photo_library, size: 18),
                    label: Text(image1 == null ? 'เลือกรูป' : 'เปลี่ยนรูป'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // การ์ดสมาชิกคนที่ 2
          Card(
            color: Colors.white,
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // รูปสมาชิกคนที่ 2
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: matchaGreen.withValues(alpha: 0.12),
                    child: image2 == null
                        ? const Icon(Icons.person, size: 50, color: matchaGreen)
                        : ClipOval(
                            child: Image.memory(
                              image2!,
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),

                  const SizedBox(height: 12),

                  // ข้อมูลสมาชิกคนที่ 2
                  const Text(
                    'ณัฏฐ์ชรินทร์ วังคีรี',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '6721652129',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: darkText.withValues(alpha: 0.7),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ปุ่มเลือกรูปสมาชิกคนที่ 2
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: matchaGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () => pickImage(2),
                    icon: const Icon(Icons.photo_library, size: 18),
                    label: Text(image2 == null ? 'เลือกรูป' : 'เปลี่ยนรูป'),
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
