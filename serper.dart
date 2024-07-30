import 'package:http/http.dart' as http;
import 'dart:convert';

class Serper {
  Future<List<Map<String, dynamic>>> serpercall(String medicinename) async {
    const serperApiKey = 'Enter your api key';

    try {
      List<Map<String, dynamic>> products = [];
      print(medicinename);
      if (medicinename.isNotEmpty) {
        var request = http.Request(
            'POST', Uri.parse('https://google.serper.dev/shopping'));
        request.body =
            json.encode({"q": 'Search the given medicine $medicinename'});
        request.headers.addAll(
            {'X-API-KEY': serperApiKey, 'Content-Type': 'application/json'});

        http.StreamedResponse serperResponse = await request.send();
        final responseString = await serperResponse.stream.bytesToString();
        print(responseString);

        final responseJson = json.decode(responseString);
        products = List<Map<String, dynamic>>.from(responseJson['shopping']);
      }
      return products;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
