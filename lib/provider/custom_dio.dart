import 'package:anima/constraint.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "custom_dio.g.dart";

@riverpod
Dio dio(DioRef ref) {
  const url = "$kApiUrl/api";

  return Dio(
    BaseOptions(
      baseUrl: url,
      headers: {"User-Agent": "anima-app"},
    ),
  );
}
