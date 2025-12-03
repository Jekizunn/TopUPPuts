import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http
import 'dart:convert'; // Import convert untuk jsonEncode
import 'dart:io'; // Untuk SocketException
import 'dart:async'; // Untuk TimeoutException
import '../models/game.dart';
import '../viewmodels/game_viewmodel.dart';
import '../config.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false; // Untuk loading spinner saat kirim data

  // 2. Fungsi untuk Mengirim Data ke Laptop (PHP)
  Future<void> submitTopUp(String gameTitle) async {
    final url = Uri.parse('${AppConfig.baseUrl}/submit.php');

    // --- 1. AMBIL TEKS DARI CONTROLLER ---
    final String inputId = _idController.text.trim(); // .trim() menghapus spasi di awal/akhir
    final String inputAmount = _amountController.text.trim();
    final String inputEmail = _emailController.text.trim();
    final String tanggalSekarang = DateTime.now().toString().substring(0, 16);

    // --- 2. VALIDASI (SATPAM) ---

    // Cek apakah ada yang kosong
    if (inputId.isEmpty || inputAmount.isEmpty || inputEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon isi semua data!"),
          backgroundColor: Colors.orange, // Warna peringatan
        ),
      );
      return; // STOP! Jangan lanjut kirim ke server
    }

    // Cek apakah Jumlah Diamond itu Angka (bukan huruf)
    if (int.tryParse(inputAmount) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jumlah Diamond harus berupa angka!"),
          backgroundColor: Colors.red,
        ),
      );
      return; // STOP!
    }

    // Cek apakah Email valid (Sederhana: harus ada '@')
    if (!inputEmail.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Format email tidak valid!"),
          backgroundColor: Colors.red,
        ),
      );
      return; // STOP!
    }

    // --- 3. JIKA LOLOS VALIDASI, BARU KIRIM ---

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'game_id': inputId,
          'game_title': gameTitle,
          'jumlah_diamond': inputAmount,
          'email': inputEmail,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          if (data['status'] == 'success') {
            if (mounted) {
              Navigator.pushNamed(
                context,
                '/success',
                arguments: {
                  'game_name': gameTitle,
                  'game_id': inputId,
                  'amount': inputAmount,
                  'email': inputEmail,
                  'date': tanggalSekarang,
                },
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(data['pesan']), backgroundColor: Colors.lightGreenAccent),
              );
            }
          }
        } catch (e) {
          throw Exception("Respon server aneh: ${response.body}");
        }
      } else {
        throw Exception('Gagal menghubungi server (Status: ${response.statusCode})');
      }
    } on SocketException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Koneksi terputus'), backgroundColor: Colors.red),
        );
      }
    } on TimeoutException {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Koneksi terputus'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. TERIMA DATA GAME DARI HOME (API PUBLIK)
    final Game game = ModalRoute.of(context)!.settings.arguments as Game;

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
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.network(
                game.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // Form Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _buildInputSection(
                    number: "1",
                    title: "Masukkan ID Game/User",
                    hintText: "Contoh: 123456",
                    controller: _idController,
                  ),
                  const SizedBox(height: 25),
                  _buildInputSection(
                    number: "2",
                    title: "Masukkan Jumlah Diamond",
                    hintText: "Contoh: 100",
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 25),
                  _buildInputSection(
                    number: "3",
                    title: "Masukkan Email",
                    hintText: "email@contoh.com",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 40),

                  // Tombol KONFIRMASI (Kirim ke PHP)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => submitTopUp(game.title),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("KONFIRMASI TOP UP",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget
  Widget _buildInputSection({
    required String number,
    required String title,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30, height: 30,
          decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
          child: Center(child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              TextField(
                controller: controller, // Pasang controller di sini
                keyboardType: keyboardType,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xAA5B5E7A),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
