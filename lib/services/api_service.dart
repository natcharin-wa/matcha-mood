import 'dart:convert';
import 'package:http/http.dart' as http;

// Service สำหรับเรียกข้อมูลจาก API
class ApiService {
  // ดึงอุณหภูมิจาก Open-Meteo API
  Future<double> getTemperature() async {
    // ส่งพิกัดของ ม.เกษตรศาสตร์ กำแพงแสนไปให้ API
    final response = await http.get(
      Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=14.022788&longitude=99.978337'
        '&current=temperature_2m',
      ),
    );

    // ถ้าเรียก API สำเร็จ ให้แปลงข้อมูล JSON
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // คืนค่าอุณหภูมิที่ได้จาก API
      return data['current']['temperature_2m'];
    }

    // ถ้าเรียก API ไม่สำเร็จ ให้แจ้งข้อผิดพลาด
    throw Exception('โหลดข้อมูลอากาศไม่สำเร็จ');
  }
}
