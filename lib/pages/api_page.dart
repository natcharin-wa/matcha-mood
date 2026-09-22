import 'package:flutter/material.dart';
import '../services/api_service.dart';

// หน้าแสดงข้อมูลอากาศจาก API
class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  // เก็บข้อมูลอุณหภูมิจาก API
  double? temperature;

  // เก็บเวลาที่อัปเดตข้อมูล
  DateTime? updateTime;

  // เรียกข้อมูลจาก API
  Future<void> loadTemperature() async {
    final result = await ApiService().getTemperature();

    setState(() {
      temperature = result;
      updateTime = DateTime.now();
    });
  }

  @override
  void initState() {
    super.initState();

    // โหลดข้อมูลทันทีเมื่อเปิดหน้า
    loadTemperature();
  }

  @override
  Widget build(BuildContext context) {
    // ถ้ายังไม่มีข้อมูล ให้แสดงตัวโหลด
    if (temperature == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ตัวแปรสำหรับเมนูที่จะแนะนำ
    String menu;
    String message;

    // แนะนำเมนูตามอุณหภูมิจาก API
    if (temperature! >= 30) {
      menu = 'Matcha Latte';
      message = 'ดื่มเย็นแล้วสดชื่น';
    } else if (temperature! >= 25) {
      menu = 'Strawberry Matcha';
      message = 'หวานหอม ดื่มง่าย';
    } else {
      menu = 'Caramel Matcha';
      message = 'หอมหวาน เหมาะกับอากาศเย็น';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ข้อมูลสภาพอากาศ')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // แสดงสถานที่ที่ใช้ขอข้อมูลอากาศ
              const Text(
                'มหาวิทยาลัยเกษตรศาสตร์\nวิทยาเขตกำแพงแสน',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 15),

              // แสดงพิกัดที่ส่งไปให้ API
              const Text(
                'Latitude: 14.022788\n'
                'Longitude: 99.978337',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // แสดงอุณหภูมิที่ได้จาก API
              Text(
                'อุณหภูมิ ${temperature!.toStringAsFixed(1)}°C',
                style: const TextStyle(fontSize: 26),
              ),

              const SizedBox(height: 15),

              // แสดงเมนูที่แนะนำตามอุณหภูมิ
              Text(
                'วันนี้แนะนำ $menu\n$message',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 20),

              // ปุ่มเรียก API ใหม่
              ElevatedButton(
                onPressed: loadTemperature,
                child: const Text('รีเฟรชข้อมูล'),
              ),

              const SizedBox(height: 10),

              // แสดงเวลาที่เรียก API ล่าสุด
              Text(
                'อัปเดตล่าสุด: ${updateTime!.hour.toString().padLeft(2, '0')}:'
                '${updateTime!.minute.toString().padLeft(2, '0')}:'
                '${updateTime!.second.toString().padLeft(2, '0')}',
              ),

              const SizedBox(height: 10),

              // บอกแหล่งข้อมูล
              const Text(
                'ข้อมูลจาก Open-Meteo API',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
