import 'package:flutter/material.dart';
import '../models/game.dart';
import '../viewmodels/game_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GameViewModel viewModel = GameViewModel();

  // Variabel untuk menyimpan data
  List<Game> _allGames = [];
  List<Game> _popularGames = [];
  List<Game> _displayGames = [];

  bool _isLoading = true;
  String _selectedCategory = "All"; // Kategori yang sedang dipilih

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fungsi ambil data & membaginya
  Future<void> _fetchData() async {
    // Tampilkan loading spinner bahkan saat refresh
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // 1. Ambil semua game dari viewmodel
      final allFetchedGames = await viewModel.fetchGames();
      
      // 2. Batasi hanya 20 game pertama
      final games = allFetchedGames.take(20).toList();

      setState(() {
        _allGames = games; // Simpan 20 game
        _popularGames = games.take(5).toList(); // Ambil 5 dari 20 game untuk populer
        _displayGames = games; // Tampilkan 20 game
        _isLoading = false;
      });
    } catch (e) {
      // Menampilkan error jika gagal memuat
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat game: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  // Fungsi Filter Kategori
  void _filterCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == "All") {
        _displayGames = _allGames;
      } else {
        // Filter berdasarkan Genre dari API
        _displayGames = _allGames.where((game) {
          return game.genre.toLowerCase().contains(category.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2D3E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2D3E),
        elevation: 0,
        title: const Text("Top Upp", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchData, // Sambungkan ke fungsi fetch data
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // Pastikan bisa di-scroll walaupun konten sedikit
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. SEARCH BAR
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Cari Game mu...",
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF393D54),
                          prefixIcon: const Icon(Icons.search, color: Colors.white54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          // Fitur cari manual sederhana
                          setState(() {
                            _displayGames = _allGames.where((g) => g.title.toLowerCase().contains(value.toLowerCase())).toList();
                          });
                        },
                      ),
                    ),

                    // 2. JUDUL POPULER
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Game Populer",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),

                    // 3. HORIZONTAL LIST (Slide)
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16),
                        itemCount: _popularGames.length,
                        itemBuilder: (context, index) {
                          return _buildPopularCard(_popularGames[index]);
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 4. KATEGORI CHIPS
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          _buildCategoryChip("All"),
                          _buildCategoryChip("Shooter"),
                          _buildCategoryChip("MMO"),
                          _buildCategoryChip("Strategy"),
                          _buildCategoryChip("Sports"),
                          _buildCategoryChip("Racing"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 5. JUDUL GAME TERBARU / LIST BAWAH
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Daftar Game ($_selectedCategory)",
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),

                    // 6. VERTICAL LIST
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true, // Agar bisa di dalam SingleChildScrollView
                      physics: const NeverScrollableScrollPhysics(), // Matikan scroll ListView, ikut scroll utama
                      itemCount: _displayGames.length,
                      itemBuilder: (context, index) {
                        return _buildVerticalCard(_displayGames[index]);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  // --- WIDGET HELPER ---

  // Kartu Horizontal (Populer)
  Widget _buildPopularCard(Game game) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: game),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(game.thumbnail),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            ),
          ),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.bottomLeft,
          child: Text(
            game.title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  // Chip Kategori
  Widget _buildCategoryChip(String category) {
    bool isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) => _filterCategory(category),
        backgroundColor: const Color(0xFF393D54),
        selectedColor: Colors.redAccent,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
      ),
    );
  }

  // Kartu Vertikal (List Bawah)
  Widget _buildVerticalCard(Game game) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: game),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF393D54),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Gambar Kecil
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(game.thumbnail, width: 80, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 15),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(game.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 5),
                  Text("${game.genre} • ${game.platform}",
                      style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            // Tombol Panah/Beli
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
              child: const Text("Top Up", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
