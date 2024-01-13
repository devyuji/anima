import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:anima/utils/clipboard.dart';
import 'package:anima/utils/custom_route_animation.dart';
import 'package:anima/utils/custom_snackbar.dart';
import 'package:anima/utils/toast.dart';
import 'package:anima/constraint.dart';
import 'package:anima/model/anime.dart';
import 'package:anima/provider/list_feed.dart';
import 'package:anima/screen/details.dart';
import 'package:anima/widgets/gap.dart';

class ListCardDetails extends ConsumerStatefulWidget {
  const ListCardDetails({super.key, required this.data});

  final Anime data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListCardDetailsState();
}

class _ListCardDetailsState extends ConsumerState<ListCardDetails> {
  int _totalEpisode = -1;
  late int _watched;
  late Status _currentStatus;

  @override
  void initState() {
    if (widget.data.episodes != "N/A") {
      _totalEpisode = int.parse(widget.data.episodes.split(" ")[0]);
    }

    _watched = widget.data.episodeWatched;
    _currentStatus = widget.data.status;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showDeleteDialog() async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          contentPadding: const EdgeInsets.all(kDefaultPadding),
          title: const Text('Delete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Sure you want to delete?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Gap(
              axis: Axis.horizontal,
              size: 5,
            ),
            TextButton(
              child: const Text(
                'Delete',
              ),
              onPressed: () {
                ref.read(listFeedProvider.notifier).delete(widget.data.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(context, "Removed from list...", true));

                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        customRouteAnimation(
                          AnimeDetails(
                            id: widget.data.malId,
                          ),
                        ),
                      );
                    },
                    label: const Text(
                      "Details",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kActionColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _showDeleteDialog,
                    icon: const Icon(Icons.delete),
                    tooltip: "Remove from list",
                  ),
                  const Gap(
                    axis: Axis.horizontal,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                    tooltip: "close",
                  )
                ],
              ),
              const Gap(),
              // status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_currentStatus != Status.watching) {
                        setState(() {
                          _currentStatus = Status.watching;
                        });
                        ref
                            .read(listFeedProvider.notifier)
                            .updateStatus(widget.data.id!, _currentStatus);
                      }
                    },
                    child: Tooltip(
                      message: "Watching",
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _currentStatus == Status.watching
                            ? (size.width / 2) - kDefaultPadding * 2
                            : (size.width / 3) - kDefaultPadding * 2,
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: _currentStatus == Status.watching
                              ? kActionColor
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.visibility, color: Colors.white),
                            AnimatedCrossFade(
                              firstChild: const SizedBox(),
                              secondChild: const Row(
                                children: [
                                  Gap(
                                    axis: Axis.horizontal,
                                  ),
                                  Text(
                                    "Watching",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              crossFadeState: _currentStatus == Status.watching
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 250),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_currentStatus != Status.planToWatch) {
                        setState(() {
                          _currentStatus = Status.planToWatch;
                          _watched = 0;
                        });
                        ref
                            .read(listFeedProvider.notifier)
                            .updateStatus(widget.data.id!, _currentStatus);
                      }
                    },
                    child: Tooltip(
                      message: "Plan to Watch",
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _currentStatus == Status.planToWatch
                            ? (size.width / 2) - kDefaultPadding * 2
                            : (size.width / 3) - kDefaultPadding * 2,
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: _currentStatus == Status.planToWatch
                              ? kActionColor
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_to_queue, color: Colors.white),
                            AnimatedCrossFade(
                              firstChild: const SizedBox(),
                              secondChild: const Row(
                                children: [
                                  Gap(
                                    axis: Axis.horizontal,
                                  ),
                                  Text(
                                    "Plan to Watch",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              crossFadeState:
                                  _currentStatus == Status.planToWatch
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 250),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_currentStatus != Status.completed) {
                        setState(() {
                          _currentStatus = Status.completed;
                        });
                        ref
                            .read(listFeedProvider.notifier)
                            .updateStatus(widget.data.id!, _currentStatus);
                      }
                    },
                    child: Tooltip(
                      message: "Completed",
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _currentStatus == Status.completed
                            ? (size.width / 2) - kDefaultPadding * 2
                            : (size.width / 3) - kDefaultPadding * 2,
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: _currentStatus == Status.completed
                              ? kActionColor
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.done_all, color: Colors.white),
                            AnimatedCrossFade(
                              firstChild: const SizedBox(),
                              secondChild: const Row(
                                children: [
                                  Gap(
                                    axis: Axis.horizontal,
                                  ),
                                  Text(
                                    "Completed",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              crossFadeState: _currentStatus == Status.completed
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 250),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(),
              // short details
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      child: Image.memory(
                        widget.data.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Gap(
                    axis: Axis.horizontal,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onLongPress: () async {
                            copyToClipboard(widget.data.title);
                            ShowToast.show("copied!");
                          },
                          child: Text(
                            widget.data.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Gap(),
                        Text(
                          "Studio : ${widget.data.studio}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const Gap(),
                        Text(
                          "Rating : ${widget.data.rating}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const Gap(),
                        Text(
                          '${widget.data.episodes} ${widget.data.episodes != "N/A" ? "Episodes" : ""}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(),
              Text(
                "You have watched $_watched episodes.",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(),
              // progress indicator
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_watched > 0) {
                        setState(() {
                          --_watched;
                        });
                        ref
                            .read(listFeedProvider.notifier)
                            .updateEpisodes(widget.data.id!, _watched);
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  const Gap(
                    axis: Axis.horizontal,
                  ),
                  Flexible(
                    child: LinearProgressIndicator(
                      value: _totalEpisode != -1 ? _watched / _totalEpisode : 1,
                    ),
                  ),
                  const Gap(
                    axis: Axis.horizontal,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (_watched < _totalEpisode || _totalEpisode == -1) {
                        setState(() {
                          _watched++;
                          _currentStatus = _totalEpisode == _watched
                              ? Status.completed
                              : Status.watching;
                        });

                        ref
                            .read(listFeedProvider.notifier)
                            .updateEpisodes(widget.data.id!, _watched);
                      }
                    },
                    icon: const Icon(Icons.add),
                    tooltip: "watched one more episodes",
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
