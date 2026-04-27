import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  late final GenerativeModel _model;
  late final String _systemPrompt;

  AIService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }

    // Following user's advice for system prompt newlines
    _systemPrompt = dotenv.env['GEMINI_SYSTEM_PROMPT']?.replaceAll(r'\n', '\n') ?? '';

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
  }

  Future<String> getFeedback({
    required String type, // 'writing' or 'speech'
    required String topic,
    required String content,
  }) async {
    if (content.isEmpty) return "Please provide some content for feedback.";

    try {
      final prompt = [
        Content.text(_systemPrompt),
        Content.text("Practice Type: $type"),
        Content.text("Topic: $topic"),
        Content.text("User Content: $content"),
        Content.text("Please provide constructive feedback based on the system instructions."),
      ];

      final response = await _model.generateContent(prompt);
      return response.text ?? "Sorry, I couldn't generate feedback at this time.";
    } catch (e) {
      return "Error connecting to AI service: $e";
    }
  }
}
