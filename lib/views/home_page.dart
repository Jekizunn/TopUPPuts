import 'package:flutter/material.dart';
import '../models/game.dart';
import '../viewmodels/game_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final GameViewModel viewModel = GameViewModel();
    final List<Game> popularGames = viewModel.getPopularGames();
    final List<Game> featuredGames = viewModel.getFeaturedGames();
    final List<String> categories = ["Mobile", "PC", "Consoles", "Voucher","Token","Wallet"];

    return Scaffold(
      backgroundColor: const Color(0xFF2A2D3E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Search Bar ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _searchBar(),
              ),

              // --- Popular Games ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Game Populer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: popularGames.length,
                        itemBuilder: (context, index) {
                          return _buildPopularGameCard(context, popularGames[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Categories ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ActionChip(
                          label: Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: const Color(0xFF3C3F58),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/kategori',
                              arguments: category,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),


              const SizedBox(height: 20),

              // --- Featured Games ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Game Unggulan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: featuredGames
                          .map((game) => _buildFeaturedGameCard(context, game))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


  // --- Helper Widgets ---

  // Search Bar
  Widget _searchBar() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.redAccent,
      decoration: InputDecoration(
        fillColor: const Color(0xFF393D54),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 24),
        suffixIcon: const Icon(Icons.tune, color: Colors.grey),
        hintText: 'Cari Game mu....',
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withAlpha(178)),
      ),
    );
  }

  // Card untuk Game Populer (Horizontal)
  Widget _buildPopularGameCard(BuildContext context, Game game) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: game.id);
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            game.bannerUrl,
            fit: BoxFit.cover,
            // Error handling jika gambar gagal dimuat
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[800],
              child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
            ),
          ),
        ),
      ),
    );
  }

  // Chip/Tombol untuk Kategori
  Widget _buildCategoryChip(BuildContext context, String category) {
    final bool isSelected = selectedCategory == category;

    return ChoiceChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          selectedCategory = selected ? category : null;
        });
      },
      backgroundColor: const Color(0xFF3C3F58),
      selectedColor: Colors.red,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: FontWeight.w600,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  // Card untuk Game Unggulan (Vertical)
  Widget _buildFeaturedGameCard(BuildContext context, Game game) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: game.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Image.network(
                game.bannerUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[800],
                  child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withAlpha(204),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}