import 'package:flutter/material.dart';
import 'views/home_page.dart';
import 'views/game_list.dart';
import 'views/top_up.dart';
import 'views/short_detail_page.dart';
import 'views/success_page.dart';
import 'views/history_page.dart';
import 'views/history_detail_page.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/kategori': (context) => const GameListPage(),
        '/detail': (context) => const ShortDetailPage(),
        '/topup': (context) => const TopUpPage(),
        '/success': (context) => const SuccessPage(),
        '/history': (context) => const HistoryPage(),
        '/history_detail': (context) => const HistoryDetailPage(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
      ),
    );
  }
}
