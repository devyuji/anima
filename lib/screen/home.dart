import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:permission_handler/permission_handler.dart";
import "package:workmanager/workmanager.dart";

import "package:anima/utils/workmanager_name.dart";
import "package:anima/screen/search/index.dart";
import "package:anima/screen/information/index.dart";
import "package:anima/screen/list.dart";
import "package:anima/screen/setting/index.dart";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _bottomNavigationIndex = 0;
  final List<int> _widgetLoaded = [0];

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _init() async {
    Workmanager().registerPeriodicTask(
      WorkManagerName.updater,
      WorkManagerName.updater,
      frequency: const Duration(days: 1),
    );
    Workmanager().registerPeriodicTask(
      WorkManagerName.checkForUpdate,
      WorkManagerName.checkForUpdate,
      frequency: const Duration(hours: 12),
    );

    await Permission.notification.request();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: _bottomNavigationIndex,
          children: [
            Visibility(
              visible: _bottomNavigationIndex == 0,
              maintainState: _widgetLoaded.contains(0),
              child: const ListScreen(),
            ),
            Visibility(
              visible: _bottomNavigationIndex == 1,
              maintainState: _widgetLoaded.contains(1),
              child: const SearchScreen(),
            ),
            Visibility(
              visible: _bottomNavigationIndex == 2,
              maintainState: _widgetLoaded.contains(2),
              child: const InformationIndexScreen(),
            ),
            Visibility(
              visible: _bottomNavigationIndex == 3,
              maintainState: _widgetLoaded.contains(3),
              child: const SettingScreen(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _bottomNavigationIndex,
          onTap: (int idx) {
            final i = _widgetLoaded.contains(idx);

            if (!i) {
              _widgetLoaded.add(idx);
            }

            setState(() {
              _bottomNavigationIndex = idx;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              activeIcon: Icon(Icons.favorite_outlined),
              label: "favorite",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded, size: 27),
              activeIcon: Icon(Icons.search_rounded, size: 27),
              label: "search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper_outlined),
              activeIcon: Icon(Icons.newspaper),
              label: "information",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: "settings",
            ),
          ],
        ),
      ),
    );
  }
}
