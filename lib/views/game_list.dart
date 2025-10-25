import 'package:flutter/material.dart';
import '../models/game.dart'; // Make sure the path is correct
import '../viewmodels/game_viewmodel.dart'; // Make sure the path is correct

class GameListPage extends StatelessWidget {
  const GameListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String category = ModalRoute.of(context)!.settings.arguments as String;
    final GameViewModel viewModel = GameViewModel();
    final List<Game> gamesInCategory = viewModel.getGamesByCategory(category);

    return Scaffold(
      backgroundColor: const Color(0xFF2A2D3E), // Background gelap
      appBar: AppBar(
        title: Text(category), // Judul AppBar sesuai kategori
        backgroundColor: const Color(0xFF393D54), // Warna AppBar
        foregroundColor: Colors.white, // Warna teks dan ikon AppBar
        elevation: 0,
      ),
      body: gamesInCategory.isEmpty
          ? const Center( // pesan jika tidak ada game di kategori ini
        child: Text(
          'Belum ada game di kategori ini.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: gamesInCategory.length,
        itemBuilder: (context, index) {
          final game = gamesInCategory[index];
          return _buildGameListItem(context, game);
        },
      ),
    );
  }

  // --- Helper Widget untuk Item List ---
  Widget _buildGameListItem(BuildContext context, Game game) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: game.id);
      },
      child: Card(
        color: const Color(0xFF3C3F58),
        margin: const EdgeInsets.only(bottom: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Colors.red.withOpacity(0.3),
            width: 1.2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  game.thumbnailUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      game.genre,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white54, size: 16),
            ],
          ),
        ),
      ),
    );
  }

}