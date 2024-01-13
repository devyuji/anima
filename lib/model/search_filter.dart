enum SearchFilterType { all, tv, movie, ova, ona, special, music }

enum SearchFilterStatus {
  all,
  airing,
  complete,
  upcoming,
}

enum SearchFilterRating {
  all,
  g,
  pg,
  pg13,
  r17,
  r,
  rx,
}

class SearchFilter {
   SearchFilter({
    required this.type,
    required this.rating,
    required this.status,
    required this.swf,
  });

   SearchFilterType type;
   SearchFilterRating rating;
   SearchFilterStatus status;
   bool swf;
}
