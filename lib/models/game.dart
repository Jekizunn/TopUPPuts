  class MinimumSystemRequirements {
    final String os;
    final String processor;
    final String memory;
    final String graphics;
    final String storage;

    MinimumSystemRequirements({
      required this.os,
      required this.processor,
      required this.memory,
      required this.graphics,
      required this.storage,
    });
  }

  class Game {
    final int id;
    final String title;
    final String genre;
    final String thumbnailUrl;
    final String bannerUrl;
    final String category;
    final bool isPopular;
    final bool isFeatured;
    final String platform;
    final String publisher;
    final String releaseDate;
    final MinimumSystemRequirements? minimumSystemRequirements;

    Game({
      required this.id,
      required this.title,
      required this.genre,
      required this.thumbnailUrl,
      required this.bannerUrl,
      required this.category,
      required this.platform,
      required this.publisher,
      required this.releaseDate,
      this.isPopular = false,
      this.isFeatured = false,
      this.minimumSystemRequirements,
    });
  }