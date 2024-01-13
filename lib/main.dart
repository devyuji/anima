import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:workmanager/workmanager.dart";

import 'package:anima/utils/version_comparision.dart';
import 'package:anima/constraint.dart';
import 'package:anima/database/anime_db.dart';
import 'package:anima/screen/home.dart';
import 'package:anima/widgets/loading.dart';
import 'package:anima/provider/view_screen.dart';
import 'package:anima/screen/onboarding/index.dart';
import "package:anima/theme.dart";
import "package:anima/utils/workmanager_name.dart";
import "package:anima/utils/notification_service.dart";

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

Future<void> _updateSilent() async {
  final data = await AnimeDB.instance.readAll();
  final dio = Dio(BaseOptions(baseUrl: "$kApiUrl/api", headers: {
    "User-Agent": "anima-app",
  }));
  try {
    for (var i = 0; i < data.length; i++) {
      final res = await dio.get("/anime/details/${data[i].malId}");
      if (res.statusCode != 200) {
        continue;
      }

      await AnimeDB.instance.updateSilent(
        data[i].id!,
        res.data['data']['score'],
        res.data['data']['episodes'],
      );
    }
  } catch (err) {
    debugPrint('$err');
  }
}

Future<bool> _checkForUpdate() async {
  try {
    const url = "https://api.github.com/repos/devyuji/anima/releases/latest";

    final res = await Dio().get(url);
    final data = res.data;
    final latestVersion = data['tag_name'];

    if (!VersionComparision.isVersionGreaterThan(
        latestVersion.replaceAll('v', ''), kAppVersion)) {
      return false;
    }

    return true;
  } catch (err) {
    return false;
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case WorkManagerName.updater:
        await _updateSilent();
        break;
      case WorkManagerName.checkForUpdate:
        if (await _checkForUpdate()) {
          NotificationService().showNotifications(
              "New Version of app is available", 0, "update");
        }
        break;
    }

    return Future.value(true);
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await NotificationService().init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final data = ref.watch(viewScreenProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "anima",
      navigatorKey: navigatorKey,
      color: Colors.black,
      theme: theme(context),
      scrollBehavior: const ScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
      home: data.when(
        data: (data) {
          if (data) {
            return const OnboardingScreen();
          } else {
            return const HomeScreen();
          }
        },
        error: (error, _) => const Center(
          child: Text("Error! Unable to open the app."),
        ),
        loading: () => const Center(
          child: RepaintBoundary(child: Loading()),
        ),
      ),
    );
  }
}
