import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Fastapi {
  static Future<List<Map<String, dynamic>>> game1(
      Future<String> responseText) async {
    final apiResponse = await http.post(
      Uri.parse('https://thetacloud-fastapi.vercel.app/chat'),
      headers: {'Content-Type': 'application/json'},
      body: json
          .encode({'question': await responseText}), // Await the responseText
    );

    print('FastAPI Response Status: ${apiResponse.statusCode}');
    try {
      if (apiResponse.statusCode == 200) {
        print('Response body');
        print(apiResponse.body);

        List<dynamic> jsonResponse = json.decode(apiResponse.body);
        print(jsonResponse);

        String innerJsonString = jsonResponse[0];
        Map<String, dynamic> decodedJson = jsonDecode(innerJsonString);
        Map<String, dynamic> response = decodedJson['response'];

        List<Map<String, dynamic>> medicineInfo = [response];

        print(medicineInfo);
        return medicineInfo;
      } else {
        return [];
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }
}
