import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'confirm_order_page.dart';
import '../controllers/cart_controller.dart';

// กรอกข้อมูลลูกค้าก่อนยืนยันออเดอร์
class CustomerInfoPage extends StatefulWidget {
  const CustomerInfoPage({super.key});

  @override
  State<CustomerInfoPage> createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
  // ตรวจสอบข้อมูลที่กรอกใน Form
  final formKey = GlobalKey<FormState>();

  // เก็บข้อมูลลูกค้า
  String name = '';
  String phone = '';

  // ประเภทการสั่งซื้อ เริ่มต้นเป็นกลับบ้าน
  String orderType = 'กลับบ้าน';

  // เก็บหมายเลขโต๊ะ ถ้าเลือกทานที่ร้าน
  int? tableNumber;

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
          'ข้อมูลลูกค้า',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ช่องกรอกชื่อลูกค้า
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ชื่อ',
                  labelStyle: const TextStyle(color: darkText),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person, color: matchaGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: matchaGreen, width: 2),
                  ),
                ),

                // ตรวจสอบว่ากรอกชื่อรึยัง
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                  return null;
                },

                // เก็บชื่อที่กรอกไว้
                onSaved: (value) {
                  name = value!;
                },
              ),

              const SizedBox(height: 20),

              // ช่องกรอกเบอร์โทรศัพท์
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'เบอร์โทรศัพท์',
                  labelStyle: const TextStyle(color: darkText),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.phone, color: matchaGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: matchaGreen, width: 2),
                  ),
                ),
                keyboardType: TextInputType.phone,

                // ตรวจสอบว่ากรอกเบอร์โทรรึยัง
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกเบอร์โทรศัพท์';
                  }
                  return null;
                },

                // เก็บเบอร์โทรที่กรอกไว้
                onSaved: (value) {
                  phone = value!;
                },
              ),

              const SizedBox(height: 25),

              // หัวข้อประเภทการสั่ง
              const Text(
                'ประเภทการสั่ง',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 8),

              // เลือกประเภทการสั่ง
              Wrap(
                spacing: 8,
                children: ['ทานที่ร้าน', 'กลับบ้าน'].map((type) {
                  final isSelected = orderType == type;

                  return ChoiceChip(
                    label: Text(
                      type,
                      style: TextStyle(
                        color: isSelected ? Colors.white : darkText,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: matchaGreen,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? matchaGreen : Colors.grey.shade300,
                    ),

                    // เปลี่ยนประเภทการสั่ง
                    onSelected: (_) {
                      setState(() {
                        orderType = type;

                        // ถ้าเลือกกลับบ้าน จะไม่ต้องใช้หมายเลขโต๊ะ
                        if (type == 'กลับบ้าน') {
                          tableNumber = null;
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              // เลือกโต๊ะ
              // แสดงเฉพาะตอนเลือกทานที่ร้าน
              if (orderType == 'ทานที่ร้าน') ...[
                const SizedBox(height: 20),

                const Text(
                  'เลือกโต๊ะ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 8),

                // สร้างปุ่มเลือกโต๊ะ 1-8
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(8, (index) {
                    int table = index + 1;
                    final isSelected = tableNumber == table;

                    return ChoiceChip(
                      label: Text(
                        'โต๊ะ $table',
                        style: TextStyle(
                          color: darkText,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: accentPink,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: isSelected ? accentPink : Colors.grey.shade300,
                      ),

                      // เก็บหมายเลขโต๊ะที่เลือก
                      onSelected: (_) {
                        setState(() {
                          tableNumber = table;
                        });
                      },
                    );
                  }),
                ),
              ],

              const SizedBox(height: 30),

              // ไปหน้ายืนยัน
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: matchaGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // ตรวจสอบข้อมูลใน Form ก่อน
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    // ถ้าทานที่ร้านต้องเลือกโต๊ะก่อน
                    if (orderType == 'ทานที่ร้าน' && tableNumber == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('กรุณาเลือกโต๊ะ')),
                      );
                      return;
                    }

                    // บันทึกค่าจาก TextFormField
                    formKey.currentState!.save();

                    // ดึงข้อมูลสินค้าจาก CartController
                    final cart = context.read<CartController>();

                    // ส่งข้อมูลลูกค้าและข้อมูลตะกร้าไปหน้ายืนยัน
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfirmOrderPage(
                          name: name,
                          phone: phone,
                          orderType: orderType,
                          tableNumber: tableNumber,
                          items: cart.items,
                          totalPrice: cart.totalPrice,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'ดำเนินการต่อ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
