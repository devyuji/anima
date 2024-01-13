class SeasonAnime {
  const SeasonAnime(
      {required this.imageUrl, required this.link, required this.title});

  final String imageUrl;
  final String link;
  final String title;

  factory SeasonAnime.fromJSON(Map<String, dynamic> data) {
    return SeasonAnime(
      imageUrl: data['image_url'],
      link: data['link'],
      title: data['title'],
    );
  }
}
