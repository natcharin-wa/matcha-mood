import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'controllers/cart_controller.dart';
import 'pages/menu_page.dart';

// จุดเริ่มต้นแอป
void main() async {
  // เตรียม Flutter ก่อนใช้ Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // เชื่อมต่อ Firebase ก่อนเริ่มแอป
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ใช้ Provider จัดการข้อมูลตะกร้า
  // CartController จะใช้ร่วมกันได้หลายหน้า
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartController(),
      child: const MyApp(),
    ),
  );
}

// Widget หลักแอป
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp ตั้งค่าหลัก/กำหนดหน้าแรก
    return MaterialApp(home: const MenuPage());
  }
}
