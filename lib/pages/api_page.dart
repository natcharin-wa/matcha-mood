import 'package:flutter/material.dart';
import '../services/api_service.dart';

// แสดงข้อมูลอากาศ
class ApiPage extends StatelessWidget {
  const ApiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matcha Mood')),
      body: FutureBuilder(
        future: ApiService().getTemperature(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final temperature = snapshot.data!;

          String menu;
          String message;

          if (temperature >= 30) {
            menu = 'Matcha Latte';
            message = 'ดื่มเย็นแล้วสดชื่น';
          } else if (temperature >= 25) {
            menu = 'Strawberry Matcha';
            message = 'หวานหอม ดื่มง่าย';
          } else {
            menu = 'Caramel Matcha';
            message = 'หอมหวาน เหมาะกับอากาศเย็น';
          }

          return Center(
            child: Text(
              'อุณหภูมิ ${temperature}°C\n'
              'วันนี้แนะนำ $menu\n'
              '$message',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
