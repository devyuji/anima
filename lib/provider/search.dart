import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:anima/model/search_details.dart';
import 'package:anima/database/search_db.dart';
import 'package:anima/model/search_filter.dart';
import 'package:anima/model/search_history.dart';

part 'search.g.dart';

@riverpod
class SearchValue extends _$SearchValue {
  @override
  String build() {
    ref.keepAlive();
    return "";
  }

  void change(String value) {
    state = value;
  }
}

@riverpod
class SearchHistoryList extends _$SearchHistoryList {
  Future<List<SearchHistory>> _getData() async {
    final data = await SearchDB.instance.readAll();

    return data.reversed.toList();
  }

  @override
  Future<List<SearchHistory>> build() => _getData();

  Future<void> add(SearchHistory data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (state.value != null && state.value!.isNotEmpty) {
        if (data.text == state.value![0].text) {
          return state.value!;
        }
      }

      if (state.value!.length >= 99) {
        remove(state.value!.last.id!);
      }
      await SearchDB.instance.add(data);
      return _getData();
    });
  }

  Future<void> remove(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await SearchDB.instance.delete(id);
      return _getData();
    });
  }
}

@riverpod
class FilterSearch extends _$FilterSearch {
  SearchFilter _getData() => SearchFilter(
        type: SearchFilterType.all,
        rating: SearchFilterRating.all,
        status: SearchFilterStatus.all,
        swf: false,
      );

  @override
  SearchFilter build() => _getData();

  void change(SearchFilter value) {
    state = value;
    ref.notifyListeners();
  }
}

@riverpod
Future<List<Search>> fetchSearchResult(FetchSearchResultRef ref,
    {required int page}) async {
  final value = ref.watch(searchValueProvider);
  final filter = ref.watch(filterSearchProvider);

  if (value.isEmpty) {
    return [];
  }

  CancelToken cancelToken = CancelToken();

  ref.onDispose(() {
    cancelToken.cancel();
  });

  final defaultQuery = {
    "q": value,
    "page": page,
    "limit": 20,
    if (filter.type != SearchFilterType.all) "type": filter.type.name,
    if (filter.status != SearchFilterStatus.all) "status": filter.status.name,
    if (filter.rating != SearchFilterRating.all) "rating": filter.rating.name,
  };

  final dio = Dio();

  final res = await dio.get(
    "https://api.jikan.moe/v4/anime",
    queryParameters: defaultQuery,
    cancelToken: cancelToken,
  );

  if (page > res.data['pagination']['last_visible_page']) {
    return [];
  }

  return res.data['data'].map<Search>((json) => Search.fromJSON(json)).toList();
}
