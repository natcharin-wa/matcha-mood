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
    return Scaffold(
      appBar: AppBar(title: const Text('ข้อมูลลูกค้า')),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ชื่อลูกค้า
              TextFormField(
                decoration: const InputDecoration(labelText: 'ชื่อ'),

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

              // เบอร์โทรศัพท์
              TextFormField(
                decoration: const InputDecoration(labelText: 'เบอร์โทรศัพท์'),
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

              const Text('ประเภทการสั่ง', style: TextStyle(fontSize: 18)),

              const SizedBox(height: 8),

              // ประเภทการสั่ง
              Wrap(
                spacing: 8,
                children: ['ทานที่ร้าน', 'กลับบ้าน'].map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: orderType == type,

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

                const Text('เลือกโต๊ะ', style: TextStyle(fontSize: 18)),

                const SizedBox(height: 8),

                // สร้างปุ่มเลือกโต๊ะ 1-8
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(8, (index) {
                    int table = index + 1;

                    return ChoiceChip(
                      label: Text('โต๊ะ $table'),
                      selected: tableNumber == table,

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
                  child: const Text('ดำเนินการต่อ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
