import 'package:flutter/material.dart';
import '../models/game.dart';
import '../viewmodels/game_viewmodel.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int gameId = ModalRoute.of(context)!.settings.arguments as int;
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
      backgroundColor: const Color(0xFF393D54),
      appBar: AppBar(
        title: const Text("Top Up"),
        backgroundColor: const Color(0xFF393D54),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Gambar Banner Game ---
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.network(
                game.bannerUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[800],
                  child: const Center(
                      child: Icon(Icons.image_not_supported,
                          color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Form Input ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  //  Masukkan ID
                  _buildInputSection(
                    number: "1",
                    title: "Masukkan ID",
                    hintText: "ID Game Anda",
                  ),
                  const SizedBox(height: 25),

                  // Masukkan Jumlah Diamond
                  _buildInputSection(
                    number: "2",
                    title: "Masukkan Jumlah Diamond",
                    hintText: "Contoh: 100",
                  ),
                  const SizedBox(height: 25),

                  // Masukkan Email
                  _buildInputSection(
                    number: "3",
                    title: "Masukkan Email",
                    hintText: "Email untuk bukti transaksi",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 40),
                  // Tombol Konfirmasi (Opsional)
                  ElevatedButton(
                     onPressed: () { /* Logika proses top up */ },
                     child: Text("Konfirmasi Top Up"),
                     style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50), // Lebar penuh
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widget untuk Setiap Bagian Input ---
  Widget _buildInputSection({
    required String number,
    required String title,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNumberIndicator(number),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: keyboardType,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xAA5B5E7A),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Indikator Angka
  Widget _buildNumberIndicator(String number) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}