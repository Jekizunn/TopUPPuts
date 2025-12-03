import 'package:flutter/material.dart';
import '../models/game.dart';

class ShortDetailPage extends StatelessWidget {
  const ShortDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. TERIMA DATA GAME DARI HOME
    final Game game = ModalRoute.of(context)!.settings.arguments as Game;

    return Scaffold(
      backgroundColor: const Color(0xFF2A2D3E),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. GAMBAR BANNER (Dari API) ---
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                game.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[800],
                  child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.white54)),
                ),
              ),
            ),

            // --- 2. KONTEN DETAIL ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Tombol Aksi Utama
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                            context,
                            '/topup',
                            arguments: game
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: const Text("LANJUT TOP UP",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Informasi Tambahan (Genre, Platform, dll)
                  const Text(
                    "Informasi Game",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildInfoChip(Icons.gamepad, game.genre),
                      _buildInfoChip(Icons.computer, game.platform),
                      _buildInfoChip(Icons.business, game.publisher),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Deskripsi Singkat
                  const Text(
                    "Deskripsi",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    game.description, // Deskripsi dari API
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5, // Jarak antar baris
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 50), // Ruang kosong bawah
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget kecil untuk kotak info (Chip)
  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF393D54),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.redAccent, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}