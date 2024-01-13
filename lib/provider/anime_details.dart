import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:anima/provider/custom_dio.dart';
import 'package:anima/model/details.dart';

part "anime_details.g.dart";

@riverpod
Future<Details> fetchDetails(FetchDetailsRef ref, {required int id}) async {
  final keepAliveLink = ref.keepAlive();
  CancelToken cancelToken = CancelToken();
  // caching for 5 minutes
  Timer(const Duration(minutes: 5), () {
    keepAliveLink.close();
  });

  ref.onDispose(() {
    cancelToken.cancel();
  });

  final dio = ref.watch(dioProvider);
  String uri = "/anime/details/$id";

  final res = await dio.get(uri, cancelToken: cancelToken);

  if (res.data['status'] != "ok") {
    throw Error();
  }

  final data = Details.fromJSON(res.data['data']);

  return data;
}

@riverpod
class IsAdded extends _$IsAdded {
  @override
  bool build() {
    return false;
  }

  void change(bool value) {
    state = value;
  }
}
