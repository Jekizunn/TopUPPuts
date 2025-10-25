import 'package:flutter/material.dart';
import '../models/game.dart'; // Sesuaikan path
import '../viewmodels/game_viewmodel.dart'; // Sesuaikan path

class ShortDetailPage extends StatelessWidget {
  const ShortDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil ID game yang dikirim
    final int gameId = ModalRoute.of(context)!.settings.arguments as int;

    // Ambil data game dari ViewModel
    final GameViewModel viewModel = GameViewModel();
    final Game? game = viewModel.getGameById(gameId);

    // Handle jika game tidak ditemukan
    if (game == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Game tidak ditemukan!")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2A2D3E),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Gambar Banner ---
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                game.bannerUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[800],
                    child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey))),
              ),
            ),
            const SizedBox(height: 16),

            // --- Judul dan Tombol Top Up ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      game.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                    label: const Text("Top Up"),
                    onPressed: () {
                      // Navigasi ke Halaman Top Up, kirim ID
                      Navigator.pushNamed(context, '/topup', arguments: game.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Info Singkat (Genre, Platform, dll.) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 16.0,
                runSpacing: 8.0,
                children: [
                  _buildInfoChip(Icons.category, game.genre),
                  _buildInfoChip(Icons.computer, game.platform),
                  _buildInfoChip(Icons.business, game.publisher),
                  _buildInfoChip(Icons.calendar_today, game.releaseDate),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Minimum System Requirements ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSystemRequirements(game.minimumSystemRequirements),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk Chip Info
  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, color: Colors.white70, size: 16),
      label: Text(text),
      backgroundColor: const Color(0xFF3C3F58),
      labelStyle: const TextStyle(color: Colors.white),
      side: BorderSide.none,
    );
  }

  // Helper widget untuk System Requirements
  Widget _buildSystemRequirements(MinimumSystemRequirements? req) {
    if (req == null) {
      return const SizedBox.shrink(); // Jangan tampilkan apa-apa jika data null
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3C3F58),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Minimum System Requirements',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          _requirementRow("OS", req.os),
          _requirementRow("Processor", req.processor),
          _requirementRow("Memory", req.memory),
          _requirementRow("Graphics", req.graphics),
          _requirementRow("Storage", req.storage),
        ],
      ),
    );
  }

  // Helper widget untuk baris requirement
  Widget _requirementRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(title, style: const TextStyle(color: Colors.white70))),
          const Expanded(flex: 1, child: Text(':', style: TextStyle(color: Colors.white70))),
          Expanded(flex: 5, child: Text(value, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}