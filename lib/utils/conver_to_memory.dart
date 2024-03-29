import 'dart:typed_data';

import 'package:dio/dio.dart';

class ConvertToMemory {
  const ConvertToMemory({required this.imageUrl});

  final String imageUrl;

  Future<Uint8List> convert() async {
    if (imageUrl.isEmpty) {
      return Uint8List.fromList([]);
    }

    final dio = Dio(
      BaseOptions(responseType: ResponseType.bytes),
    );

    try {
      final res = await dio.get(imageUrl);
      return Uint8List.fromList(res.data);
    } catch (err) {
      return Uint8List.fromList([]);
    }
  }
}
