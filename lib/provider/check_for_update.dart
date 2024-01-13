import "package:dio/dio.dart";
import "package:flutter/services.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "package:anima/constraint.dart";
import "package:anima/model/app_update.dart";
import "package:anima/utils/version_comparision.dart";

part 'check_for_update.g.dart';

@riverpod
Future<AppUpdate> checkForUpdate(CheckForUpdateRef ref) async {
  const url = "https://api.github.com/repos/devyuji/anima/releases/latest";

  final res = await Dio().get(url);
  final data = res.data;
  final latestVersion = data['tag_name'];

  if (!VersionComparision.isVersionGreaterThan(
      latestVersion.replaceAll('v', ''), kAppVersion)) {
    return AppUpdate(
      body: "App is up to date",
      version: latestVersion,
    );
  }

  const platform = MethodChannel('devyuji.com/anima');
  final supportedABIS = await platform.invokeMethod('SupportedAbis');
  for (var i in data['assets']) {
    String name = i['name'];

    if (name.contains(supportedABIS)) {
      return AppUpdate(
        updateAvailable: true,
        body: data['body'],
        version: latestVersion,
        downloadUrl: i['browser_download_url'],
      );
    }
  }

  return const AppUpdate();
}
