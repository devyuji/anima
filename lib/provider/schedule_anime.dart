import 'package:anima/model/schedule.dart';
import 'package:anima/provider/custom_dio.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_anime.g.dart';

@riverpod
Future<List<ScheduleAnime>> fetchScheduleAnime(FetchScheduleAnimeRef ref,
    {required DateTime date}) async {
  ref.keepAlive();
  final dio = ref.watch(dioProvider);

  final cancelToken = CancelToken();

  final currentDate = date.millisecondsSinceEpoch ~/ 1000;

  final lastTime =
      date.add(const Duration(days: 1)).millisecondsSinceEpoch ~/ 1000;

  ref.onDispose(() {
    cancelToken.cancel();
  });

  final res = await dio.get("/anime/schedule?from=$currentDate&to=$lastTime",
      cancelToken: cancelToken);

  if (res.statusCode != 200) throw Error();

  return res.data['schedules']
      .map<ScheduleAnime>((json) => ScheduleAnime.fromJSON(json))
      .toList();
}
