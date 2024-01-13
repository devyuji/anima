class Details {
  const Details({
    required this.title,
    required this.alternativeTitles,
    required this.description,
    required this.coverImage,
    required this.type,
    required this.episodes,
    required this.status,
    required this.premiered,
    required this.genres,
    required this.duration,
    required this.studios,
    required this.rating,
    required this.score,
    required this.source,
    required this.aired,
    this.relatedAnime,
  });

  final String title;
  final List<String> alternativeTitles;
  final String description;
  final String coverImage;
  final String type;
  final String episodes;
  final String status;
  final String premiered;
  final List<String> genres;
  final String duration;
  final List<String> studios;
  final String rating;
  final String score;
  final String source;
  final String aired;
  final List<RelatedAnime>? relatedAnime;

  factory Details.fromJSON(Map<String, dynamic> data) {
    return Details(
      title: data['title'],
      aired: data['aired'],
      source: data['source'],
      score: data['score'],
      alternativeTitles: data['alternative_titles'].cast<String>(),
      coverImage: data['cover_image'],
      description: data['description'],
      duration: data['duration'],
      episodes: data['episodes'],
      genres: data['genres'].cast<String>(),
      premiered: data['premiered'],
      rating: data['rating'],
      status: data['status'],
      studios: data['studios'].cast<String>(),
      type: data['type'],
      relatedAnime: data['related_anime']
          ?.map<RelatedAnime>((rel) => RelatedAnime.fromJSON(rel))
          .toList(),
    );
  }
}

class RelatedAnime {
  RelatedAnime({required this.section, required this.links});

  final String section;
  final List<RelatedAnimeLinks> links;

  factory RelatedAnime.fromJSON(Map<String, dynamic> data) {
    return RelatedAnime(
      section: data['section'],
      links: data['links']
          .map<RelatedAnimeLinks>(
            (l) => RelatedAnimeLinks.fromJSON(l),
          )
          .toList(),
    );
  }
}

class RelatedAnimeLinks {
  RelatedAnimeLinks({required this.name, required this.url});

  final String name;
  final String url;

  factory RelatedAnimeLinks.fromJSON(Map<String, dynamic> data) {
    return RelatedAnimeLinks(
      name: data['name'],
      url: data['url'],
    );
  }
}
