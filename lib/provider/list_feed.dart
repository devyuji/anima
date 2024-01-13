import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:anima/database/anime_db.dart';
import 'package:anima/model/anime.dart';

part "list_feed.g.dart";

enum Filter {
  all,
  watching,
  planToWatch,
  completed,
}

@riverpod
class ListFeed extends _$ListFeed {
  Future<List<Anime>> _getData() async {
    final data = await AnimeDB.instance.readAll();
    return data;
  }

  @override
  Future<List<Anime>> build() async {
    return _getData();
  }

  Future<void> add(Anime data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await AnimeDB.instance.add(data);

      return _getData();
    });
  }

  Future<void> updateEpisodes(int id, int value) async {
    await AnimeDB.instance.updateEpisode(id, value);
    final idx = state.value!.indexWhere((element) => element.id == id);
    if (state.value![idx].episodes != "N/A") {
      if (int.parse(state.value![idx].episodes.split(" ")[0]) == value) {
        await updateStatus(id, Status.completed);
      }
    }
    state.value![idx].episodeWatched = value;

    if (state.value![idx].status == Status.planToWatch) {
      final filter = ref.read(filterAnimeProvider);

      if (filter != Filter.all) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() async {
          await AnimeDB.instance.updateStatus(id, Status.watching);
          return _getData();
        });
      } else {
        state.value![idx].status = Status.watching;
      }
    }
  }

  Future<void> updateStatus(int id, Status value) async {
    final filter = ref.read(filterAnimeProvider);
    final idx = state.value!.indexWhere((element) => element.id == id);
    state.value![idx].status = value;

    if (value == Status.planToWatch) {
      await AnimeDB.instance.updateEpisode(id, 0);
      state.value![idx].episodeWatched = 0;
    }

    if (filter != Filter.all) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        await AnimeDB.instance.updateStatus(id, value);

        return _getData();
      });
    }
  }

  Future<void> delete(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await AnimeDB.instance.delete(id);
      return _getData();
    });
  }

  bool find(int id) {
    final isPresent =
        state.value!.where((element) => element.malId == id).isNotEmpty;

    return isPresent;
  }

  Future<void> updateSilent(String rating, String episode, int id) async {
    await AnimeDB.instance.updateSilent(id, rating, episode);

    final idx = state.value!.indexWhere((element) => element.id == id);
    state.value![idx].rating = rating;
    state.value![idx].episodes = episode;
  }

  Future<void> refresh(
      {required int id,
      required String rating,
      required String episode,
      required Uint8List image}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await AnimeDB.instance
          .refresh(episodes: episode, id: id, image: image, rating: rating);

      return _getData();
    });
  }
}

@riverpod
class FilterAnime extends _$FilterAnime {
  @override
  Filter build() => Filter.watching;

  void update(Filter value) {
    state = value;
  }
}

@riverpod
Future<List<Anime>> filterList(FilterListRef ref) async {
  final filter = ref.watch(filterAnimeProvider);
  final data = await ref.watch(listFeedProvider.future);

  switch (filter) {
    case Filter.all:
      return data.reversed.toList();
    case Filter.watching:
      return data
          .where((element) => element.status.name == Filter.watching.name)
          .toList()
          .reversed
          .toList();
    case Filter.planToWatch:
      return data
          .where((element) => element.status.name == Filter.planToWatch.name)
          .toList()
          .reversed
          .toList();
    case Filter.completed:
      return data
          .where((element) => element.status.name == Filter.completed.name)
          .toList()
          .reversed
          .toList();
  }
}
