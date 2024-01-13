import 'package:anima/model/season_anime.dart';
import 'package:anima/provider/custom_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "season_anime.g.dart";

enum SeasonAnimeFilter {
  current,
  prev,
  next,
}

@riverpod
class FilterSeason extends _$FilterSeason {
  @override
  SeasonAnimeFilter build() => SeasonAnimeFilter.current;

  void update(SeasonAnimeFilter value) {
    state = value;
  }
}

@riverpod
Future<List<SeasonAnime>> seasonAnime(SeasonAnimeRef ref) async {
  ref.keepAlive();
  final dio = ref.watch(dioProvider);
  final filter = ref.watch(filterSeasonProvider);

  final res = await dio.get("/anime/season?sea=${filter.name}");

  if (res.statusCode != 200 || res.data['status'] != "ok") {
    throw Error();
  }

  return res.data['data']
      .map<SeasonAnime>((json) => SeasonAnime.fromJSON(json))
      .toList();
}
