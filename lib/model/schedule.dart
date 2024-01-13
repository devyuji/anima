import 'dart:convert';
import 'dart:typed_data';

class ScheduleAnime {
  const ScheduleAnime(
      {required this.episode,
      required this.image,
      required this.time,
      required this.title});
  final Uint8List image;
  final String title;
  final int time;
  final int episode;

  factory ScheduleAnime.fromJSON(Map<String, dynamic> data) {
    return ScheduleAnime(
      episode: data['episode'],
      image: base64Decode(data['image']),
      time: data['airing_at'],
      title: data['title'],
    );
  }
}
