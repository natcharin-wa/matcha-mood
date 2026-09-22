import 'package:flutter/material.dart';
import 'confirm_order_page.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';

// หน้ากรอกข้อมูลลูกค้า
class CustomerInfoPage extends StatefulWidget {
  const CustomerInfoPage({super.key});

  @override
  State<CustomerInfoPage> createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
  // ตรวจสอบข้อมูลในฟอร์ม
  final formKey = GlobalKey<FormState>();

  // เก็บข้อมูลลูกค้า
  String name = '';
  String phone = '';
  String orderType = 'กลับบ้าน';
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
              // ช่องกรอกชื่อ
              TextFormField(
                decoration: const InputDecoration(labelText: 'ชื่อ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),

              const SizedBox(height: 20),

              // ช่องกรอกเบอร์โทร
              TextFormField(
                decoration: const InputDecoration(labelText: 'เบอร์โทรศัพท์'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกเบอร์โทรศัพท์';
                  }
                  return null;
                },
                onSaved: (value) {
                  phone = value!;
                },
              ),

              const SizedBox(height: 25),

              const Text('ประเภทการสั่ง', style: TextStyle(fontSize: 18)),

              const SizedBox(height: 8),

              // เลือกทานที่ร้านหรือกลับบ้าน
              Wrap(
                spacing: 8,
                children: ['ทานที่ร้าน', 'กลับบ้าน'].map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: orderType == type,
                    onSelected: (_) {
                      setState(() {
                        orderType = type;

                        if (type == 'กลับบ้าน') {
                          tableNumber = null;
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              // ถ้าทานที่ร้าน ให้เลือกโต๊ะ
              if (orderType == 'ทานที่ร้าน') ...[
                const SizedBox(height: 20),

                const Text('เลือกโต๊ะ', style: TextStyle(fontSize: 18)),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(8, (index) {
                    int table = index + 1;

                    return ChoiceChip(
                      label: Text('โต๊ะ $table'),
                      selected: tableNumber == table,
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

              // ปุ่มไปหน้ายืนยันออเดอร์
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // ตรวจสอบข้อมูลก่อนส่งต่อ
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    // ถ้าทานที่ร้านต้องเลือกโต๊ะ
                    if (orderType == 'ทานที่ร้าน' && tableNumber == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('กรุณาเลือกโต๊ะ')),
                      );
                      return;
                    }

                    formKey.currentState!.save();

                    // ดึงข้อมูลตะกร้า
                    final cart = context.read<CartController>();

                    // ส่งข้อมูลไปหน้า Confirm Order
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
