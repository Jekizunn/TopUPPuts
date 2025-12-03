import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class GameViewModel {
  final String _baseUrl = 'https://www.freetogame.com/api/games';

  Future<List<Game>> fetchGames() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        // Konversi JSON ke List<Game>
        return jsonData.map((item) => Game.fromJson(item)).toList();
      } else {
        throw Exception('Gagal ambil data dari server');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Game>> fetchGamesByCategory(String category) async {
    final String url = '$_baseUrl?category=$category';
    
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Game.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat game untuk kategori $category');
      }
    } catch (e) {
      throw Exception('Error saat mengambil data: $e');
    }
  }
}