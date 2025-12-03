import 'package:flutter/material.dart';
import '../models/game.dart';
import '../viewmodels/game_viewmodel.dart';

class GameListPage extends StatefulWidget {
  const GameListPage({super.key});

  @override
  State<GameListPage> createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  late Future<List<Game>> _gamesFuture;
  final GameViewModel viewModel = GameViewModel();
  String? _category;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_category == null) {
      final categoryArg = ModalRoute.of(context)!.settings.arguments as String;
      _category = categoryArg;
      _gamesFuture = viewModel.fetchGamesByCategory(categoryArg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2D3E),
      appBar: AppBar(
        title: Text(_category ?? 'Games'),
        backgroundColor: const Color(0xFF393D54),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Game>>(
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada game di kategori ini.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          } else {
            final games = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return _buildGameListItem(context, game);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildGameListItem(BuildContext context, Game game) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: game);
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
                  game.thumbnail, 
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
