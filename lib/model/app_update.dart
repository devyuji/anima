import 'package:anima/constraint.dart';

class AppUpdate {
  const AppUpdate({
    this.updateAvailable = false,
    this.version = kAppVersion,
    this.downloadUrl = "",
    this.body = "",
  });

  final bool updateAvailable;
  final String version;
  final String body;
  final String downloadUrl;
}
