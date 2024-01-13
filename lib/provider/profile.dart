import 'package:anima/database/profile_db.dart';
import 'package:anima/model/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "profile.g.dart";

@riverpod
class FetchProfile extends _$FetchProfile {
  Future<Profile> _getData() async {
    final value = await ProfileDB.instance.read();

    return value;
  }

  @override
  Future<Profile> build() => _getData();

  Future<void> add(Profile data) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ProfileDB.instance.add(data);

      return _getData();
    });
  }
}
