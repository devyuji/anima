import 'package:flutter/material.dart';

import 'package:anima/screen/information/news.dart';
import 'package:anima/screen/information/season.dart';
import 'package:anima/widgets/indicator.dart';

class InformationIndexScreen extends StatefulWidget {
  const InformationIndexScreen({super.key});

  @override
  State<InformationIndexScreen> createState() => _InformationIndexScreenState();
}

class _InformationIndexScreenState extends State<InformationIndexScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();

    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              floating: true,
              toolbarHeight: 70,
              title: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _tabController.animateTo(0);
                        },
                        child: const Text(
                          "News",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _tabController.index <= 0.5,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: const Indicator(),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _tabController.animateTo(1);
                        },
                        child: const Text(
                          "Season Anime",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _tabController.index >= 1,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: const Indicator(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: const [
          NewsScreen(),
          SeasonScreen(),
        ],
      ),
    );
  }
}
