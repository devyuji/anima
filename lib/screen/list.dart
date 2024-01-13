import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:anima/screen/upcomming.dart';
import 'package:anima/constraint.dart';
import 'package:anima/provider/list_feed.dart';
import 'package:anima/utils/custom_route_animation.dart';
import 'package:anima/widgets/custom_modal_bottom_sheet.dart';
import 'package:anima/widgets/loading.dart';
import 'package:anima/widgets/gap.dart';
import 'package:anima/widgets/list_card_details.dart';
import 'package:anima/widgets/anime_card.dart';
import 'package:anima/widgets/indicator.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(filterListProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(listFeedProvider.future),
      backgroundColor: kPrimaryColor,
      color: kActionColor,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight!,
            title: const Text("Your list"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    customRouteAnimation(
                      const UpcommingScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.movie_creation),
                tooltip: "Airing anime",
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: FilterMenuHeader(ref: ref),
            ),
          ),
          data.when(
            data: (data) {
              if (data.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/images/empty_list.svg",
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        const Gap(),
                        const Text(
                          "Your list is empty!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => GestureDetector(
                      onTap: () {
                        customModalBottomSheet(
                          context,
                          (context) => ListCardDetails(data: data[index]),
                        );
                      },
                      child: AnimeCard(
                        title: data[index].title,
                        image: data[index].image,
                      ),
                    ),
                    childCount: data.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 280,
                    crossAxisSpacing: kDefaultPadding,
                    mainAxisSpacing: kDefaultPadding,
                  ),
                ),
              );
            },
            error: (err, _) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/error.svg",
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      const Gap(size: 5),
                      const Text(
                        "Something went wrong!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(),
                      const Text("Pull to refresh"),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: RepaintBoundary(child: Loading()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterMenuHeader extends SliverPersistentHeaderDelegate {
  const FilterMenuHeader({required this.ref});

  final WidgetRef ref;
  final double maxHeight = 65;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final filter = ref.watch(filterAnimeProvider);

    bool currentFilter(Filter value) {
      return filter == value;
    }

    return Container(
      color: kBackgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    ref.read(filterAnimeProvider.notifier).update(Filter.all);
                  },
                  child: Text(
                    "All",
                    style: TextStyle(
                      color: currentFilter(Filter.all)
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                Visibility(
                  visible: currentFilter(Filter.all),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: const Indicator(),
                ),
              ],
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(filterAnimeProvider.notifier)
                        .update(Filter.watching);
                  },
                  child: Text(
                    "Watching",
                    style: TextStyle(
                      color: currentFilter(Filter.watching)
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                Visibility(
                  visible: currentFilter(Filter.watching),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: const Indicator(),
                ),
              ],
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(filterAnimeProvider.notifier)
                        .update(Filter.planToWatch);
                  },
                  child: Text(
                    "Plan to Watch",
                    style: TextStyle(
                      color: currentFilter(Filter.planToWatch)
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                Visibility(
                  visible: currentFilter(Filter.planToWatch),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: const Indicator(),
                ),
              ],
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(filterAnimeProvider.notifier)
                        .update(Filter.completed);
                  },
                  child: Text(
                    "Completed",
                    style: TextStyle(
                      color: currentFilter(Filter.completed)
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                Visibility(
                  visible: currentFilter(Filter.completed),
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
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => maxHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
