import 'package:flutter/material.dart';
import 'views/home_page.dart';
import 'views/game_list.dart'; // Mengaktifkan import
import 'views/top_up.dart'; // Mengaktifkan import
import 'views/short_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Top Up',
      initialRoute: '/', // Halaman awal
      routes: {
        '/': (context) => const HomePage(),
        '/kategori': (context) => const GameListPage(),
        '/detail': (context) => const ShortDetailPage(),
        '/topup': (context) => const TopUpPage(),
      },
      theme: ThemeData(
        brightness: Brightness.dark, //tema app
        primarySwatch: Colors.deepOrange,
      ),
    );
  }
}
