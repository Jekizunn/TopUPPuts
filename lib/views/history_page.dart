
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../config.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _emailController = TextEditingController();
  List<dynamic> _historyData = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;

  Future<void> fetchHistory() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi email dulu!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _historyData = [];
      _errorMessage = null;
    });

    final String email = _emailController.text.trim();
    final url = Uri.parse('${AppConfig.baseUrl}/history.php?email=$email');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            _historyData = data['data'];
          });
        } else if (data['status'] == 'empty') {
        } else {
           setState(() {
              _errorMessage = data['pesan'] ?? "Terjadi kesalahan pada server.";
           });
        }
      } else {
        setState(() {
          _errorMessage = "Gagal terhubung ke server (Error: ${response.statusCode})";
        });
      }
    } on SocketException {
      setState(() {
        _errorMessage = "Tidak dapat tersambung ke data base";
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Terjadi kesalahan: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2D3E),
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        backgroundColor: const Color(0xFF2A2D3E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- BAGIAN PENCARIAN ---
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF393D54),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Cek Riwayat via Email...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.white54),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : fetchHistory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Cari", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- BAGIAN HASIL (LIST) ---
            Expanded(
              child: buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan konten utama
  Widget buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(
          child: Text(_errorMessage!,
              style: const TextStyle(color: Colors.white70)));
    }
    
    if (_historyData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _hasSearched ? Icons.history_toggle_off : Icons.search,
              size: 80,
              color: Colors.white24,
            ),
            const SizedBox(height: 10),
            Text(
              _hasSearched
                  ? "Belum ada riwayat transaksi untuk email ini."
                  : "Masukkan email untuk melihat riwayat.",
              style: const TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: _historyData.length,
      itemBuilder: (context, index) {
        final item = _historyData[index];
        return Card(
          color: const Color(0xFF393D54),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/history_detail', arguments: item);
            },
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green),
            ),
            title: Text(
              "${item['game_title']}",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text("Game ID: ${item['game_id']}",
                    style: const TextStyle(color: Colors.white70)),
                Text("Jumlah: ${item['jumlah_diamond']} Diamonds",
                    style: const TextStyle(color: Colors.white70)),
                Text("Waktu: ${item['tanggal']}",
                    style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.white24),
          ),
        );
      },
    );
  }
}
