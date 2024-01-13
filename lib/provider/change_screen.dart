import 'package:riverpod_annotation/riverpod_annotation.dart';

part "change_screen.g.dart";

@riverpod
class ChangeScreen extends _$ChangeScreen {
  @override
  int build() => 1;

  void update(int value) {
    state = value;
  }
}
