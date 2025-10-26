import '../models/game.dart'; // Pastikan path import model benar

class GameViewModel {
  final List<Game> _dummyGames = [
    Game(
        id: 1,
        title: "Call of Duty: Warzone",
        genre: "Battle Royale",
        thumbnailUrl: "https://cdn.mobygames.com/covers/18400061-call-of-duty-warzone-mobile-iphone-front-cover.png", // Ganti URL
        bannerUrl: "https://cdn.oneesports.id/cdn-data/sites/2/2024/03/COD-Warzone-Mobile.jpg", // Ganti URL
        category: "PC",
        platform: "PC, PS5, Xbox Series X/S", // Contoh
        publisher: "Activision", // Contoh
        releaseDate: "2020-03-10", // Contoh
        isPopular: true,
        isFeatured: true,
        minimumSystemRequirements: MinimumSystemRequirements( // Contoh
        os: "Windows 10 64-bit",
        processor: "Intel Core i3-4340 or AMD FX-6300",
        memory: "8 GB RAM",
        graphics: "NVIDIA GeForce GTX 670 / GeForce GTX 1650 or Radeon HD 7950",
        storage: "175 GB"
        )
    ),
    Game(
        id: 2,
        title: "Apex Legends",
        genre: "Battle Royale",
        thumbnailUrl: "https://upload.wikimedia.org/wikipedia/commons/b/b1/Apex_legends_simple_logo.jpg", // Ganti URL
        bannerUrl: "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/1172470/f002ac48d98f501231e7d8bd3cc418b65c8d511a/capsule_616x353.jpg?t=1754578148", // Ganti URL
        category: "PC",
        isPopular: true,
        isFeatured: true,
        platform: "PC, PS4, Xbox One, Switch", // Contoh
        publisher: "Electronic Arts", // Contoh
        releaseDate: "2019-02-04", // Contoh
        minimumSystemRequirements: MinimumSystemRequirements( // Contoh
            os: "Windows 7 64-bit",
            processor: "Intel Core i3-6300 3.8GHz / AMD FX-4350 4.2 GHz",
            memory: "6 GB RAM",
            graphics: "NVIDIA GeForce GT 640 / Radeon HD 7730",
            storage: "22 GB"
        )
    ),
    Game(
        id: 3,
        title: "Valorant",
        genre: "Tactical Shooter",
        thumbnailUrl: "https://pbs.twimg.com/profile_images/1247587680881434629/5e1tJWpf_400x400.jpg", // Ganti URL
        bannerUrl: "https://i0.wp.com/www.gimbot.com/wp-content/uploads/2022/11/VALORANT-Featured.jpg?fit=1200%2C675&ssl=1", // Ganti URL
        category: "PC",
        isPopular: true,
        isFeatured: true,
        platform: "PC, PS4, Xbox One, Switch", // Contoh
        publisher: "Electronic Arts", // Contoh
        releaseDate: "2019-02-04", // Contoh
        minimumSystemRequirements: MinimumSystemRequirements( // Contoh
            os: "Windows 7 64-bit",
            processor: "Intel Core i3-6300 3.8GHz / AMD FX-4350 4.2 GHz",
            memory: "6 GB RAM",
            graphics: "NVIDIA GeForce GT 640 / Radeon HD 7730",
            storage: "22 GB"
        )
    ),
    Game(
        id: 4,
        title: "League of Legends: Wild Rift",
        genre: "MOBA",
        thumbnailUrl: "https://i.pinimg.com/474x/0f/03/d7/0f03d71550ab2b51e63091b6af05befb.jpg", // Ganti URL
        bannerUrl: "https://blue.kumparan.com/image/upload/fl_progressive,fl_lossy,c_fill,f_auto,q_auto:best,w_640/v1571219351/qac2nnb942ezunfz0usr.jpg", // Ganti URL
        category: "Mobile",
        isPopular: true,
        isFeatured: true,
        platform: "PC, PS4, Xbox One, Switch", // Contoh
        publisher: "Electronic Arts", // Contoh
        releaseDate: "2019-02-04", // Contoh
        minimumSystemRequirements: MinimumSystemRequirements( // Contoh
            os: "Windows 7 64-bit",
            processor: "Intel Core i3-6300 3.8GHz / AMD FX-4350 4.2 GHz",
            memory: "6 GB RAM",
            graphics: "NVIDIA GeForce GT 640 / Radeon HD 7730",
            storage: "22 GB"
        )
    ),
    // Tambahkan data game lainnya...
  ];

  // Fungsi untuk mengambil semua game (nanti bisa dimodifikasi)
  List<Game> loadAllGames() {
    return _dummyGames;
  }

  // Fungsi untuk mengambil game populer
  List<Game> getPopularGames() {
    return _dummyGames.where((game) => game.isPopular).toList();
  }

  // Fungsi untuk mengambil game unggulan
  List<Game> getFeaturedGames() {
    return _dummyGames.where((game) => game.isFeatured).toList();
  }

  // Fungsi untuk mengambil game berdasarkan ID (untuk halaman detail)
  Game? getGameById(int id) {
    try {
      return _dummyGames.firstWhere((game) => game.id == id);
    } catch (e) {
      return null; // Return null jika game tidak ditemukan
    }
  }

  // Fungsi untuk mengambil game berdasarkan Kategori (untuk halaman list)
  List<Game> getGamesByCategory(String category) {
    return _dummyGames.where((game) => game.category.toLowerCase() == category.toLowerCase()).toList();
  }
}