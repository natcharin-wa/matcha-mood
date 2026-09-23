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
    // ขอข้อมูลอุณหภูมิจาก API
    final result = await ApiService().getTemperature();

    // อัปเดตข้อมูลที่แสดงบนหน้า
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
    // โทนสีของหน้า API
    const matchaGreen = Color(0xFF557C2B);
    const accentPink = Color(0xFFEFB7F7);
    const bgCream = Color(0xFFFAF5EF);
    const darkText = Color(0xFF2C3E1F);

    // ถ้ายังไม่มีข้อมูล ให้แสดงตัวโหลด
    if (temperature == null) {
      return const Scaffold(
        backgroundColor: bgCream,
        body: Center(child: CircularProgressIndicator(color: matchaGreen)),
      );
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
      backgroundColor: bgCream,

      appBar: AppBar(
        backgroundColor: matchaGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'ข้อมูลสภาพอากาศ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // การ์ดแสดงข้อมูลสภาพอากาศและเมนูแนะนำ
              Card(
                color: Colors.white,
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // ไอคอนสภาพอากาศ
                      const Icon(
                        Icons.thermostat_rounded,
                        size: 48,
                        color: matchaGreen,
                      ),

                      const SizedBox(height: 10),

                      // แสดงสถานที่ที่ใช้ขอข้อมูลอากาศ
                      const Text(
                        'มหาวิทยาลัยเกษตรศาสตร์\n'
                        'วิทยาเขตกำแพงแสน',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // แสดงพิกัดที่ส่งไปให้ API
                      Text(
                        'Latitude: 14.022788\n'
                        'Longitude: 99.978337',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: darkText.withValues(alpha: 0.6),
                        ),
                      ),

                      const Divider(height: 30),

                      // แสดงอุณหภูมิที่ได้จาก API
                      Text(
                        'อุณหภูมิ ${temperature!.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: matchaGreen,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // แสดงเมนูที่แนะนำตามอุณหภูมิ
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: bgCream,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: accentPink),
                        ),
                        child: Text(
                          'วันนี้แนะนำ $menu\n$message',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ปุ่มเรียก API ใหม่
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: matchaGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: loadTemperature,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'รีเฟรชข้อมูล',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // แสดงเวลาที่เรียก API ล่าสุด
              Text(
                'อัปเดตล่าสุด: '
                '${updateTime!.hour.toString().padLeft(2, '0')}:'
                '${updateTime!.minute.toString().padLeft(2, '0')}:'
                '${updateTime!.second.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 13,
                  color: darkText.withValues(alpha: 0.7),
                ),
              ),

              const SizedBox(height: 6),

              // บอกแหล่งข้อมูล
              Text(
                'ข้อมูลจาก Open-Meteo API',
                style: TextStyle(
                  fontSize: 12,
                  color: darkText.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
