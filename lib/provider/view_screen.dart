import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "view_screen.g.dart";

@riverpod
class ViewScreen extends _$ViewScreen {
  @override
  Future<bool> build() async {
    final pref = await SharedPreferences.getInstance();
    final b = pref.getBool("viewScreen") ?? true;

    return b;
  }

  Future<void> change(bool value) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final pref = await SharedPreferences.getInstance();
      pref.setBool("viewScreen", value);
      return Future.value(value);
    });
  }
}
