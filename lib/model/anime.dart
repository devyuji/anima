import 'dart:typed_data';

enum AnimeStatus {
  completed,
  airing,
  notAired,
}

enum Status {
  watching,
  planToWatch,
  completed,
}

class Anime {
  Anime({
    required this.title,
    this.image,
    required this.studio,
    required this.rating,
    required this.episodes,
    required this.malId,
    required this.animeStatus,
    this.id,
    this.imageUrl = "",
    this.episodeWatched = 0,
    this.status = Status.watching,
  });

  final String title;
  Uint8List? image;
  final String studio;
  String rating;
  String episodes;
  final int? id;
  final int malId;
  final AnimeStatus animeStatus;
  Status status;
  int episodeWatched;

  String imageUrl;

  factory Anime.fromJSON(Map<String, dynamic> data) {
    return Anime(
      episodes: data['episodes'],
      image: data['image'],
      malId: data['malId'],
      rating: data['rating'],
      status: Status.values.firstWhere((e) => e.name == data["status"]),
      studio: data['studio'],
      title: data['title'],
      episodeWatched: data['episodeWatched'],
      id: data['id'],
      animeStatus:
          AnimeStatus.values.firstWhere((e) => e.name == data["animeStatus"]),
    );
  }

  static Map<String, dynamic> toJSON(Anime data) {
    return {
      "title": data.title,
      "image": data.image,
      "studio": data.studio,
      "rating": data.rating,
      "episodes": data.episodes,
      "status": data.status.name,
      "malId": data.malId,
      "episodeWatched": data.episodeWatched,
      "animeStatus": data.animeStatus.name,
    };
  }
}
