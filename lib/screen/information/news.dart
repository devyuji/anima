import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:intl/intl.dart";
import "package:url_launcher/url_launcher.dart";

import "package:anima/widgets/loading.dart";
import "package:anima/constraint.dart";
import "package:anima/provider/news.dart";
import "package:anima/widgets/gap.dart";

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewsScreen> createState() => _State();
}

class _State extends ConsumerState<NewsScreen> {
  Future<void> _goTo(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: kPrimaryColor,
      color: kActionColor,
      onRefresh: () => ref.refresh(fetchNewsProvider(page: 1).future),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final page = index ~/ 20;
                final itemIndex = index % 20;

                final news = ref.watch(fetchNewsProvider(page: page + 1));

                return news.when(
                  data: (data) {
                    if (itemIndex >= data.length) return null;

                    DateTime date = DateTime.fromMillisecondsSinceEpoch(
                        data[itemIndex].published * 1000);
                    String formattedDate =
                        DateFormat('dd MMM yyyy, hh:mm a').format(date);

                    return GestureDetector(
                      onTap: () => _goTo(data[index].source.url),
                      child: Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  data[itemIndex].source.name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Gap(
                                  size: 10,
                                  axis: Axis.horizontal,
                                ),
                                const Icon(Icons.north_east_outlined, size: 17),
                              ],
                            ),
                            const Gap(),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kDefaultPadding),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: data[itemIndex].image.isEmpty
                                    ? Container(
                                        color: kPrimaryColor,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.hide_image_outlined,
                                              size: 50,
                                              color: Colors.grey.shade500,
                                            ),
                                            const Gap(size: 10),
                                            Text(
                                              'NO PHOTO',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey.shade500,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: data[itemIndex].image,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, progress) {
                                          return Container(
                                            color: kBackgroundColor,
                                            alignment: Alignment.center,
                                            child: LinearProgressIndicator(
                                              value: progress.progress,
                                            ),
                                          );
                                        },
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          "assets/images/no_image.jfif",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                            const Gap(),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const Gap(),
                            Text(
                              data[itemIndex].title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
                            height: MediaQuery.of(context).size.height * 0.25,
                          ),
                          const Gap(),
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
                    );
                  },
                  loading: () {
                    if (itemIndex != 0) return null;
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(kDefaultPadding),
                        child: RepaintBoundary(
                          child: Loading(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
