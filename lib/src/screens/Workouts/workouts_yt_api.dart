import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class YouTubeService {
  final String _apiKey = dotenv.env['YOUTUBE_API_KEY'] ?? '';
  final String _baseUrl = dotenv.env['YOUTUBE_API_BASE_URL'] ?? '';

  Future<List<dynamic>> searchVideos(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search?part=snippet&q=$query&type=video&key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['items'];
    } else {
      throw Exception('Failed to load videos');
    }
  }
}
