import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/cart_item.dart';
import '../controllers/cart_controller.dart';

// ปรับแต่งเครื่องดื่มก่อนเพิ่มลงตะกร้า
class CustomizePage extends StatefulWidget {
  // สินค้าที่เลือกจากหน้าเมนู
  final Product product;

  const CustomizePage({super.key, required this.product});

  @override
  State<CustomizePage> createState() => _CustomizePageState();
}

class _CustomizePageState extends State<CustomizePage> {
  // ค่าที่เลือกไว้เริ่มต้น
  int sweetness = 50;
  String drinkType = 'เย็น';
  String iceLevel = 'ปกติ';
  List<String> selectedToppings = [];
  List<String> selectedExtras = [];

  // รายการเมนูที่สามารถเลือกแบบปั่นได้
  final blendMenu = [
    'Matcha Latte',
    'Caramel Matcha',
    'Oreo Matcha',
    'Taro Matcha',
    'Banana Matcha',
    'Biscoff Cream Matcha',
  ];

  // ราคาของท็อปปิ้งแต่ละชนิด
  final toppingPrices = {
    'วิปครีม': 15,
    'ไข่มุก': 10,
    'บุก': 15,
    'บิสคอฟ': 15,
    'โอรีโอครัมเบิล': 15,
    'ถั่วแดง': 15,
    'เยลลี่สตรอว์เบอร์รี': 15,
    'ซอสคาราเมล': 10,
  };

  // ราคาของเพิ่มเติม
  final extraPrices = {'Matcha Shot': 20, 'Honey': 10};

  @override
  Widget build(BuildContext context) {
    // เช็กว่าเมนูที่เลือกสามารถปั่นได้มั้ย
    final canBlend = blendMenu.contains(widget.product.name);

    return Scaffold(
      appBar: AppBar(title: const Text('Customize')),

      // ใช้ ListView เพื่อให้หน้าเลื่อนได้
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // แสดงชื่อเมนูที่กำลังปรับแต่ง
          Text(widget.product.name, style: const TextStyle(fontSize: 24)),

          const SizedBox(height: 20),

          // ความหวาน
          const Text('ความหวาน'),

          Wrap(
            children: [0, 25, 50, 75, 100].map((value) {
              return ChoiceChip(
                label: Text('$value%'),
                selected: sweetness == value,

                // เมื่อเลือกความหวาน ให้เปลี่ยนค่าที่เก็บไว้
                onSelected: (_) {
                  setState(() {
                    sweetness = value;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 15),

          // ประเภทเครื่องดื่ม
          const Text('ประเภทเครื่องดื่ม'),

          Wrap(
            children: [
              // เลือกแบบเย็น
              ChoiceChip(
                label: const Text('เย็น'),
                selected: drinkType == 'เย็น',
                onSelected: (_) {
                  setState(() {
                    drinkType = 'เย็น';
                  });
                },
              ),

              // แสดงปุ่มปั่นเฉพาะเมนูที่ปั่นได้
              if (canBlend)
                ChoiceChip(
                  label: const Text('ปั่น +15'),
                  selected: drinkType == 'ปั่น',
                  onSelected: (_) {
                    setState(() {
                      drinkType = 'ปั่น';
                    });
                  },
                ),
            ],
          ),

          // ระดับน้ำแข็ง
          // แสดงเฉพาะตอนเลือกเครื่องดื่มแบบเย็น
          if (drinkType == 'เย็น') ...[
            const SizedBox(height: 15),
            const Text('ระดับน้ำแข็ง'),

            Wrap(
              children: ['ไม่ใส่น้ำแข็ง', 'น้อย', 'ปกติ', 'เยอะ'].map((ice) {
                return ChoiceChip(
                  label: Text(ice),
                  selected: iceLevel == ice,

                  // เปลี่ยนระดับน้ำแข็งที่เลือก
                  onSelected: (_) {
                    setState(() {
                      iceLevel = ice;
                    });
                  },
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 15),

          // ท็อปปิ้ง
          const Text('ท็อปปิ้ง'),

          Wrap(
            children: toppingPrices.keys.map((topping) {
              return FilterChip(
                label: Text('$topping +${toppingPrices[topping]}'),
                selected: selectedToppings.contains(topping),

                // เพิ่มหรือเอาท็อปปิ้งออกจากรายการที่เลือก
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedToppings.add(topping);
                    } else {
                      selectedToppings.remove(topping);
                    }
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 15),

          // ของเพิ่มเติม
          const Text('เพิ่มเติม'),

          Wrap(
            children: extraPrices.keys.map((extra) {
              return FilterChip(
                label: Text('$extra +${extraPrices[extra]}'),
                selected: selectedExtras.contains(extra),

                // เพิ่มหรือเอาของเพิ่มเติมออกจากรายการที่เลือก
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedExtras.add(extra);
                    } else {
                      selectedExtras.remove(extra);
                    }
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 25),

          // เพิ่มลงตะกร้า
          ElevatedButton(
            onPressed: () {
              // ราคาท็อปปิ้งเป็น 0
              int toppingPrice = 0;

              // ถ้าเลือกแบบปั่น จะเพิ่มราคา 15 บาท
              int extraPrice = drinkType == 'ปั่น' ? 15 : 0;

              // รวมราคาท็อปปิ้งที่เลือกทั้งหมด
              for (var topping in selectedToppings) {
                toppingPrice += toppingPrices[topping]!;
              }

              // รวมราคาของเพิ่มเติมที่เลือก
              for (var extra in selectedExtras) {
                extraPrice += extraPrices[extra]!;
              }

              // สร้าง CartItem แล้วเพิ่มลงในตะกร้า
              context.read<CartController>().addItem(
                CartItem(
                  widget.product,
                  1,
                  sweetness,
                  drinkType,
                  iceLevel,
                  selectedToppings,
                  selectedExtras,
                  toppingPrice,
                  extraPrice,
                ),
              );

              // เพิ่มเสร็จแล้วกลับไปหน้าก่อนหน้า
              Navigator.pop(context);
            },
            child: const Text('เพิ่มลงตะกร้า'),
          ),
        ],
      ),
    );
  }
}
