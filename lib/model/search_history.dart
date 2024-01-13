class SearchHistory {
  SearchHistory({ this.id, required this.text});

  final int? id;
  final String text;

  factory SearchHistory.fromJSON(Map<String, dynamic> data) {
    return SearchHistory(text: data['text'], id: data["id"]);
  }

  Map<String, dynamic> toJSON() {
    return {
      if (id != null) "id": id,
      "text": text,
    };
  }
}