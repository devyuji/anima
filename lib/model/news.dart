class News {
  const News({
    required this.title,
    required this.source,
    required this.description,
    required this.image,
    required this.published,
  });

  final String title;
  final String image;
  final String description;
  final NewsSource source;
  final int published;

  factory News.fromJSON(Map<String, dynamic> data) {
    return News(
      title: data['title'],
      source: NewsSource.fromJSON(data['source']),
      description: data['description'],
      image: data['image'],
      published: data['published'],
    );
  }
}

class NewsSource {
  const NewsSource({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  factory NewsSource.fromJSON(Map<String, dynamic> data) {
    return NewsSource(
      name: data['name'],
      url: data['url'],
    );
  }
}
