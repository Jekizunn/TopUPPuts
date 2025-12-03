class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String description;
  final String genre;
  final String platform;
  final String publisher;

  Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.genre,
    required this.platform,
    required this.publisher,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      description: json['short_description'],
      genre: json['genre'],
      platform: json['platform'],
      publisher: json['publisher'],
    );
  }
}