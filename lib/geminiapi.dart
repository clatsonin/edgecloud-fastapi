import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class GeminiApi {
  final XFile xfilePick;

  GeminiApi({required this.xfilePick});

  Future<String> sendImageToGeminiAPI() async {
    const apiKey = 'Enter your api key';

    try {
      final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          safetySettings: [
            SafetySetting(
                HarmCategory.dangerousContent, HarmBlockThreshold.none)
          ]);
      final imageBytes = await File(xfilePick.path).readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([
        Content.multi([
          TextPart(
              "Analyze the photo of the medicine and provide the full medicine name. If the photo is not of a medicine or is not clearly visible, the output will be 'retry'.Output will be full medicine name or 'retry'."),
          imagePart
        ])
      ]);

      final responseText = response.text ?? 'No response text';
      print(responseText);
      return responseText;
    } catch (e) {
      print('Error in gemini: $e');
      return '';
    }
  }
}
