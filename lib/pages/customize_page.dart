import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../controllers/cart_controller.dart';

// ปรับแต่งเครื่องดื่ม
class CustomizePage extends StatefulWidget {
  final Product product;

  const CustomizePage({super.key, required this.product});

  @override
  State<CustomizePage> createState() => _CustomizePageState();
}

class _CustomizePageState extends State<CustomizePage> {
  // ค่าที่เลือก
  int sweetness = 50;
  String drinkType = 'เย็น';
  String iceLevel = 'ปกติ';
  List<String> selectedToppings = [];
  List<String> selectedExtras = [];

  // เมนูที่ปั่นได้
  final blendMenu = [
    'Matcha Latte',
    'Caramel Matcha',
    'Oreo Matcha',
    'Taro Matcha',
    'Banana Matcha',
    'Biscoff Cream Matcha',
  ];

  // ราคาท็อปปิ้ง
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

  // ราคาเพิ่มเติม
  final extraPrices = {'Matcha Shot': 20, 'Honey': 10};

  @override
  Widget build(BuildContext context) {
    // เช็กว่าเมนูนี้ปั่นได้มั้ย
    final canBlend = blendMenu.contains(widget.product.name);

    return Scaffold(
      appBar: AppBar(title: const Text('Customize')),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ชื่อเมนู
          Text(widget.product.name, style: const TextStyle(fontSize: 24)),

          const SizedBox(height: 20),

          // เลือกความหวาน
          const Text('ความหวาน'),
          Wrap(
            children: [0, 25, 50, 75, 100].map((value) {
              return ChoiceChip(
                label: Text('$value%'),
                selected: sweetness == value,
                onSelected: (_) {
                  setState(() {
                    sweetness = value;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 15),

          // เลือกประเภทเครื่องดื่ม
          const Text('ประเภทเครื่องดื่ม'),
          Wrap(
            children: [
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

          // เลือกระดับน้ำแข็งเฉพาะเครื่องดื่มเย็น
          if (drinkType == 'เย็น') ...[
            const SizedBox(height: 15),
            const Text('ระดับน้ำแข็ง'),
            Wrap(
              children: ['ไม่ใส่น้ำแข็ง', 'น้อย', 'ปกติ', 'เยอะ'].map((ice) {
                return ChoiceChip(
                  label: Text(ice),
                  selected: iceLevel == ice,
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

          // เลือกท็อปปิ้ง
          const Text('ท็อปปิ้ง'),
          Wrap(
            children: toppingPrices.keys.map((topping) {
              return FilterChip(
                label: Text('$topping +${toppingPrices[topping]}'),
                selected: selectedToppings.contains(topping),
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

          // เลือกของเพิ่มเติม
          const Text('เพิ่มเติม'),
          Wrap(
            children: extraPrices.keys.map((extra) {
              return FilterChip(
                label: Text('$extra +${extraPrices[extra]}'),
                selected: selectedExtras.contains(extra),
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
              // คำนวณราคาท็อปปิ้งและของเพิ่มเติม
              int toppingPrice = 0;
              int extraPrice = drinkType == 'ปั่น' ? 15 : 0;

              for (var topping in selectedToppings) {
                toppingPrice += toppingPrices[topping]!;
              }

              for (var extra in selectedExtras) {
                extraPrice += extraPrices[extra]!;
              }

              // เพิ่มข้อมูลลงตะกร้า
              context.read<CartController>().addItem(
                CartItem(
                  widget.product,
                  1,
                  sweetness,
                  drinkType,
                  iceLevel,
                  selectedToppings,
                  toppingPrice,
                  extraPrice,
                ),
              );

              // กลับหน้าก่อนหน้า
              Navigator.pop(context);
            },
            child: const Text('เพิ่มลงตะกร้า'),
          ),
        ],
      ),
    );
  }
}
