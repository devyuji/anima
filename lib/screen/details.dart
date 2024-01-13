import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:expandable_text/expandable_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:url_launcher/url_launcher.dart";
import "package:flutter_svg/flutter_svg.dart";

import "package:anima/utils/conver_to_memory.dart";
import "package:anima/utils/toast.dart";
import "package:anima/model/details.dart";
import "package:anima/utils/custom_route_animation.dart";
import "package:anima/widgets/back.dart";
import "package:anima/widgets/loading.dart";
import "package:anima/widgets/custom_modal_bottom_sheet.dart";
import "package:anima/constraint.dart";
import "package:anima/model/anime.dart";
import "package:anima/provider/anime_details.dart";
import "package:anima/provider/list_feed.dart";
import "package:anima/widgets/add_to_list.dart";
import "package:anima/widgets/gap.dart";

class AnimeDetails extends ConsumerStatefulWidget {
  const AnimeDetails({super.key, required this.id});

  final int id;

  @override
  ConsumerState<AnimeDetails> createState() => _AnimeDetailsState();
}

class _AnimeDetailsState extends ConsumerState<AnimeDetails> {
  @override
  void initState() {
    super.initState();
    _isPresent();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _isPresent() async {
    final list = await ref.read(listFeedProvider.future);

    final v = (list.indexWhere((element) => element.malId == widget.id)) != -1;
    ref.read(isAddedProvider.notifier).change(v);
  }

  Widget _add(AsyncValue<Details> data) {
    String studioName = "";

    for (var s = 0; s < data.value!.studios.length; s++) {
      studioName += data.value!.studios[s];

      if ((s + 1) != data.value!.studios.length) {
        studioName += ", ";
      }
    }

    final convertData = Anime(
      title: data.value!.title,
      imageUrl: data.value!.coverImage,
      studio: studioName,
      rating: data.value!.score,
      episodes: data.value!.episodes,
      malId: widget.id,
      animeStatus: AnimeStatus.airing,
    );

    return AddToList(
      data: convertData,
      showDetails: false,
    );
  }

  Future<void> _refresh() async {
    try {
      final data = await ref.read(FetchDetailsProvider(id: widget.id).future);

      final img = await ConvertToMemory(imageUrl: data.coverImage).convert();

      ref.read(listFeedProvider.notifier).refresh(
            id: widget.id,
            episode: data.episodes,
            rating: data.score,
            image: img,
          );

      ShowToast.show("Refreshing data..");
    } catch (err) {
      debugPrint('$err');
      ShowToast.show("Unable to refresh data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(fetchDetailsProvider(id: widget.id));
    final isAdded = ref.watch(isAddedProvider);

    return Scaffold(
      body: RefreshIndicator(
        backgroundColor: kPrimaryColor,
        color: kActionColor,
        onRefresh: () async =>
            await ref.refresh(fetchDetailsProvider(id: widget.id).future),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              leading: backButton(context),
              actions: [
                Visibility(
                  visible: !data.isLoading && !data.hasError,
                  child: isAdded
                      ? IconButton(
                          onPressed: _refresh,
                          icon: const Icon(Icons.refresh),
                        )
                      : TextButton.icon(
                          onPressed: () {
                            customModalBottomSheet(
                              context,
                              (context) {
                                return _add(data);
                              },
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Add to List"),
                        ),
                ),
              ],
            ),
            data.when(
              data: (data) {
                return SliverPadding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // cover and details
                        SizedBox(
                          height: 400,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius),
                                  child: CachedNetworkImage(
                                    imageUrl: data.coverImage,
                                    height: double.infinity,
                                    width: double.infinity,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Gap(axis: Axis.horizontal, size: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(
                                          kDefaultPadding * 0.4),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(
                                            kBorderRadius),
                                        border: Border.all(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          const Icon(Icons.info,
                                              color: Colors.white),
                                          const Gap(size: 5),
                                          Text(
                                            "Status",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const Gap(
                                            size: 10,
                                          ),
                                          Text(
                                            data.status,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                          )
                                        ],
                                      ),
                                    ),
                                    const Gap(size: 5),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(
                                          kDefaultPadding * 0.4),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(
                                            kBorderRadius),
                                        border: Border.all(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          const Icon(Icons.videocam,
                                              color: Colors.white),
                                          const Gap(),
                                          Text(
                                            "Episodes",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const Gap(
                                            size: 10,
                                          ),
                                          Text(
                                            data.episodes,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Gap(size: 5),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(
                                          kDefaultPadding * 0.4),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(
                                            kBorderRadius),
                                        border: Border.all(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.white),
                                          const Gap(),
                                          Text(
                                            "Rating",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const Gap(
                                            size: 10,
                                          ),
                                          Text(
                                            data.score,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const Gap(),

                        // title
                        Text(
                          data.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(size: kDefaultPadding * 0.5),
                        Divider(
                          color: kActionColor.withOpacity(0.2),
                          thickness: 1,
                        ),
                        const Gap(),

                        // description
                        const Text(
                          "Synopsis",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(size: kDefaultPadding * .5),
                        ExpandableText(
                          data.description,
                          expandText: "Show more",
                          collapseOnTextTap: true,
                          maxLines: 5,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                          expandOnTextTap: true,
                          linkColor: kActionColor,
                        ),
                        const Gap(),

                        // additional information
                        const Text(
                          "Additional Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(kDefaultPadding * 0.4),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            border: Border.all(
                              color: kPrimaryColor,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.subtitles_outlined,
                                  color: Colors.white),
                              const Gap(),
                              Text(
                                "Alternative Titles",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Gap(
                                size: 10,
                              ),
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                spacing: kDefaultPadding,
                                children: data.alternativeTitles.map((e) {
                                  return Text(
                                    e,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                        const Gap(),
                        Container(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            border: Border.all(
                              color: kPrimaryColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Type",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  const Gap(),
                                  Text(
                                    data.type,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Premiered",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  const Gap(),
                                  Text(
                                    data.premiered,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Duration",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  const Gap(),
                                  Text(
                                    data.duration,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(kDefaultPadding / 2),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            border: Border.all(
                              color: kPrimaryColor,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: "Studios : ",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    children: [
                                      ...data.studios
                                          .map((e) => TextSpan(text: "$e, ")),
                                    ]),
                              ),
                              const Gap(),
                              Text(
                                "Rating : ${data.rating}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(),
                              Text(
                                "Source : ${data.source}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(),
                              Text(
                                "Aired : ${data.aired}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(),
                              RichText(
                                text: TextSpan(
                                  text: "Genres : ",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    ...data.genres
                                        .map((e) => TextSpan(text: "$e, ")),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Gap(),
                        if (data.relatedAnime != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Related Anime",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Gap(),
                              ...data.relatedAnime!.map(
                                (e) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: kDefaultPadding * 0.3),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.section,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        for (var rl in e.links)
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                customRouteAnimation(
                                                  AnimeDetails(
                                                    id: int.parse(rl.url),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                rl.name,
                                                style: const TextStyle(
                                                  color: kActionColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                        const Gap(),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(kActionColor),
                            ),
                            onPressed: () async {
                              Uri uri = Uri.parse(
                                  "http://myanimelist.net/anime/${widget.id}");

                              await launchUrl(uri);
                            },
                            icon: const Icon(
                              Icons.arrow_drop_up,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Visit myanimelist.net",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              error: (error, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/images/error.svg",
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      const Text(
                        "Anime not found! 404",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(size: kDefaultPadding * 2),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Go Back"))
                    ],
                  ),
                ),
              ),
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Center(
                    child: RepaintBoundary(child: Loading()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
