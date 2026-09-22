import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'controllers/cart_controller.dart';
import 'pages/menu_page.dart';

// จุดเริ่มต้นแอป
void main() async {
  // เตรียม Flutter ก่อนเริ่ม Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // เชื่อม Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // เริ่มแอปและจัดการข้อมูลตะกร้าด้วย Provider
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartController(),
      child: const MyApp(),
    ),
  );
}

// ตั้งค่าหลักของแอป
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // กำหนดหน้าแรกของแอป
    return MaterialApp(home: const MenuPage());
  }
}
