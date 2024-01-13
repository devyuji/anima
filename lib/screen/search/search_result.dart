import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:anima/screen/search/widget/filter.dart';
import 'package:anima/utils/debouncer.dart';
import 'package:anima/widgets/back.dart';
import 'package:anima/widgets/custom_modal_bottom_sheet.dart';
import 'package:anima/widgets/loading.dart';
import 'package:anima/provider/list_feed.dart';
import 'package:anima/screen/details.dart';
import 'package:anima/widgets/gap.dart';
import 'package:anima/constraint.dart';
import 'package:anima/model/anime.dart';
import 'package:anima/model/search_details.dart';
import 'package:anima/provider/search.dart';
import 'package:anima/widgets/add_to_list.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  const SearchResultScreen({super.key});

  @override
  ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  late TextEditingController _textController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    final value = ref.read(searchValueProvider);

    _textController = TextEditingController(text: value);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showDetails(Search result) {
    AnimeStatus status;
    if (result.status == "not yet aired") {
      status = AnimeStatus.notAired;
    } else if (result.status == "finish airing") {
      status = AnimeStatus.completed;
    } else {
      status = AnimeStatus.airing;
    }

    final convertData = Anime(
      title: result.title,
      imageUrl: result.image,
      studio: result.studio,
      rating: result.rating,
      episodes: result.episodes,
      malId: result.id,
      animeStatus: status,
    );

    final isPresent = ref.read(listFeedProvider.notifier).find(result.id);

    if (isPresent) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AnimeDetails(id: result.id),
        ),
      );
    } else {
      customModalBottomSheet(
        context,
        (context) => AddToList(data: convertData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              leading: backButton(context),
              toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight!,
              actions: [
                IconButton(
                  onPressed: () {
                    customModalBottomSheet(
                      context,
                      (_) => const SearchFilterScreen(),
                    );
                  },
                  icon: const Icon(Icons.filter_alt_rounded),
                  tooltip: "filter",
                ),
              ],
            ),

            // search field
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchFieldDelegate(
                ref: ref,
                controller: _textController,
                scrollController: _scrollController,
              ),
            ),

            const SliverToBoxAdapter(
              child: Gap(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final page = index ~/ 20;
                  final itemIndex = index % 20;

                  final searchData =
                      ref.watch(fetchSearchResultProvider(page: page + 1));

                  return searchData.when(
                    data: (data) {
                      if (itemIndex >= data.length) return null;

                      return GestureDetector(
                        onTap: () {
                          _showDetails(data[itemIndex]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding / 2,
                            horizontal: kDefaultPadding,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius),
                                  child: CachedNetworkImage(
                                    imageUrl: data[itemIndex].image,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            kDefaultPadding / 2),
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Gap(axis: Axis.horizontal),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data[itemIndex].title,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Gap(size: 10),
                                    Text(
                                      "Studio : ${data[itemIndex].studio}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Gap(size: 10),
                                    Text(
                                      "Rating : ${data[itemIndex].rating}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Gap(size: 10),
                                    Text(
                                      "${data[itemIndex].episodes} ${data[itemIndex].episodes != "N/A" ? "Episodes" : ""}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    error: (error, _) {
                      if (itemIndex != 0) return null;

                      return Padding(
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
                          ],
                        ),
                      );
                    },
                    loading: () {
                      if (itemIndex != 0) return null;

                      return const Padding(
                        padding: EdgeInsets.all(kDefaultPadding),
                        child: Center(
                          child: RepaintBoundary(child: Loading()),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Text(
                  "Powered by jikan.moe API.",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchFieldDelegate extends SliverPersistentHeaderDelegate {
  SearchFieldDelegate({
    required this.ref,
    required this.controller,
    required this.scrollController,
  });

  final double maxHeight = 64.0;
  final WidgetRef ref;
  final TextEditingController controller;
  final ScrollController scrollController;
  final _debouncer = Debouncer(milliseconds: 1000);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: kBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(kDefaultPadding),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey.shade500,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.close),
            ),
            suffixIconColor: Colors.grey.shade300,
            filled: true,
            fillColor: kPrimaryColor,
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) {
            _debouncer.run(() {
              scrollController.animateTo(
                scrollController.position.minScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(),
              );

              ref.read(searchValueProvider.notifier).change(value);
            });
          },
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
