class Search {
  const Search({
    required this.title,
    required this.id,
    required this.rating,
    required this.image,
    required this.studio,
    required this.episodes,
    required this.status,
  });

  final int id;
  final String title;
  final String rating;
  final String image;
  final String studio;
  final String episodes;
  final String status;

  factory Search.fromJSON(Map<String, dynamic> data) {
    String studioName = "";

    for (var s = 0; s < data['studios'].length; s++) {
      studioName += "${data['studios'][s]['name']}";

      if ((s + 1) != data['studios'].length) {
        studioName += ", ";
      }
    }

    return Search(
      title: data["title"],
      id: data["mal_id"],
      rating: data['score'] != null ? data['score'].toString() : "N/A",
      image: data["images"]["jpg"]["image_url"],
      studio: studioName.isEmpty ? "?" : studioName,
      episodes:
          data['episodes'] != null ? "${data['episodes']}" : "N/A",
      status: data['status'].toString().toLowerCase(),
    );
  }
}
