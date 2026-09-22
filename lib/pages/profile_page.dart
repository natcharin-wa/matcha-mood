import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  // เลือกรูปจากเครื่อง
  Future<void> pickImage(int member) async {
    // เปิดหน้าต่างให้เลือกรูปจาก Gallery
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    // ถ้าเลือกรูปแล้ว นำรูปมาใช้งาน
    if (picked != null) {
      // อ่านรูปเป็นข้อมูลแบบ bytes
      final bytes = await picked.readAsBytes();

      // อัปเดตรูปที่แสดงบนหน้า
      setState(() {
        if (member == 1) {
          image1 = bytes;
        } else {
          image2 = bytes;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สมาชิก')),

      // ใช้ ListView เพื่อให้หน้าสามารถเลื่อนดูสมาชิกได้
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // สมาชิกคนที่ 1
          CircleAvatar(
            radius: 55,
            child: image1 == null
                // ถ้ายังไม่มีรูป ให้แสดงไอคอนคน
                ? const Icon(Icons.person, size: 50)
                // ถ้ามีรูปแล้ว ให้แสดงรูปที่เลือก
                : ClipOval(
                    child: Image.memory(
                      image1!,
                      width: 110,
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),

          const SizedBox(height: 10),

          // ข้อมูลสมาชิกคนที่ 1
          const Text('นางสาวธนิดา ดิษเทศ', textAlign: TextAlign.center),
          const Text('6721652242', textAlign: TextAlign.center),

          // ปุ่มเลือกรูปสมาชิกคนที่ 1
          ElevatedButton(
            onPressed: () => pickImage(1),
            child: const Text('เลือกรูป'),
          ),

          const SizedBox(height: 30),

          // สมาชิกคนที่ 2
          CircleAvatar(
            radius: 55,
            child: image2 == null
                // ถ้ายังไม่มีรูป ให้แสดงไอคอนคน
                ? const Icon(Icons.person, size: 50)
                // ถ้ามีรูปแล้ว ให้แสดงรูปที่เลือก
                : ClipOval(
                    child: Image.memory(
                      image2!,
                      width: 110,
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),

          const SizedBox(height: 10),

          // ข้อมูลสมาชิกคนที่ 2
          const Text('ณัฏฐ์ชรินทร์ วังคีรี', textAlign: TextAlign.center),
          const Text('6721652129', textAlign: TextAlign.center),

          // ปุ่มเลือกรูปสมาชิกคนที่ 2
          ElevatedButton(
            onPressed: () => pickImage(2),
            child: const Text('เลือกรูป'),
          ),
        ],
      ),
    );
  }
}
