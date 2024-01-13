import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:anima/utils/custom_route_animation.dart";
import "package:anima/widgets/custom_modal_bottom_sheet.dart";
import "package:anima/widgets/gap.dart";
import "package:anima/widgets/loading.dart";
import "package:anima/constraint.dart";
import "package:anima/provider/season_anime.dart";
import "package:anima/screen/details.dart";
import "package:anima/widgets/anime_card.dart";

class SeasonScreen extends ConsumerStatefulWidget {
  const SeasonScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SeasonScreen> createState() => _SeasonScreenState();
}

class _SeasonScreenState extends ConsumerState<SeasonScreen> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(seasonAnimeProvider);

    return RefreshIndicator(
      backgroundColor: kPrimaryColor,
      color: kActionColor,
      onRefresh: () async => await ref.refresh(seasonAnimeProvider.future),
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SeasonOption(
              ref: ref,
            ),
          ),
          data.when(
            data: (data) {
              return SliverPadding(
                padding: const EdgeInsets.all(kDefaultPadding),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          customRouteAnimation(
                            AnimeDetails(id: int.parse(data[index].link)),
                          ),
                        ),
                        child: AnimeCard(
                          title: data[index].title,
                          image: data[index].imageUrl,
                        ),
                      );
                    },
                    childCount: data.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 280,
                    mainAxisSpacing: kDefaultPadding,
                    crossAxisSpacing: kDefaultPadding,
                  ),
                ),
              );
            },
            error: (error, _) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/error.svg",
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
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
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: RepaintBoundary(child: Loading()),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Center(
                child: Text(
                  "All information are from myanimelist.net",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SeasonOption extends SliverPersistentHeaderDelegate {
  const SeasonOption({required this.ref});
  final double maxHeight = 50;

  final WidgetRef ref;

  void _showSeasonMenu(BuildContext context) {
    final selectedSeason = ref.read(filterSeasonProvider);
    customModalBottomSheet(
      context,
      (context) {
        return Wrap(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 3,
                margin: const EdgeInsets.all(kDefaultPadding / 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            RadioListTile<SeasonAnimeFilter>(
              value: selectedSeason,
              groupValue: SeasonAnimeFilter.prev,
              onChanged: (value) {
                ref
                    .read(filterSeasonProvider.notifier)
                    .update(SeasonAnimeFilter.prev);
                Navigator.pop(context);
              },
              title: const Text("Previous Season"),
            ),
            RadioListTile<SeasonAnimeFilter>(
              value: selectedSeason,
              groupValue: SeasonAnimeFilter.current,
              onChanged: (value) {
                ref
                    .read(filterSeasonProvider.notifier)
                    .update(SeasonAnimeFilter.current);
                Navigator.pop(context);
              },
              title: const Text("Current Season"),
            ),
            RadioListTile<SeasonAnimeFilter>(
              value: selectedSeason,
              groupValue: SeasonAnimeFilter.next,
              onChanged: (value) {
                ref
                    .read(filterSeasonProvider.notifier)
                    .update(SeasonAnimeFilter.next);
                Navigator.pop(context);
              },
              title: const Text("Next Season"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final selectedSeason = ref.watch(filterSeasonProvider);

    return Container(
      color: kBackgroundColor,
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () => _showSeasonMenu(context),
        label: Text(
          "${selectedSeason.name[0].toUpperCase()}${selectedSeason.name.substring(1)} Season",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        icon: const Icon(Icons.expand_more, color: Colors.white),
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
