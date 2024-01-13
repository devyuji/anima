import 'dart:async';

import 'package:anima/model/news.dart';
import 'package:anima/provider/custom_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "news.g.dart";

@riverpod
Future<List<News>> fetchNews(FetchNewsRef ref, {required int page}) async {
  ref.keepAlive();
  final dio = ref.watch(dioProvider);

  final res = await dio.get("/anime/news", queryParameters: {
    "page": page,
  });

  if (res.data['status'] != "ok" || res.statusCode != 200) {
    throw Error();
  }

  if (page > res.data['pagination']['total_page']) return [];

  return res.data['news'].map<News>((json) => News.fromJSON(json)).toList();
}
