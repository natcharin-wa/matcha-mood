import 'dart:convert';
import 'package:http/http.dart' as http;

// ใช้เรียกข้อมูลอากาศ
class ApiService {
  Future<double> getTemperature() async {
    final response = await http.get(
      Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=13.8478&longitude=100.5714'
        '&current=temperature_2m',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['current']['temperature_2m'];
    }

    throw Exception('โหลดข้อมูลอากาศไม่สำเร็จ');
  }
}
