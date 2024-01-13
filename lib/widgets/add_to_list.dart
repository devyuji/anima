import 'package:anima/provider/anime_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:anima/utils/conver_to_memory.dart';
import 'package:anima/utils/custom_route_animation.dart';
import 'package:anima/utils/custom_snackbar.dart';
import 'package:anima/screen/details.dart';
import 'package:anima/constraint.dart';
import 'package:anima/model/anime.dart';
import 'package:anima/provider/list_feed.dart';
import 'package:anima/widgets/gap.dart';

class AddToList extends ConsumerStatefulWidget {
  const AddToList({super.key, required this.data, this.showDetails = true});

  final Anime data;
  final bool showDetails;

  @override
  ConsumerState<AddToList> createState() => _AddToListState();
}

class _AddToListState extends ConsumerState<AddToList> {
  Status _selectedStatus = Status.planToWatch;
  late TextEditingController _textController;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: "0");
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      setState(() {
        _loading = true;
      });
      final data = widget.data;
      data.episodeWatched = int.tryParse(_textController.text) ?? 0;
      data.status = _selectedStatus;
      data.image =
          await ConvertToMemory(imageUrl: widget.data.imageUrl).convert();
      ref.read(listFeedProvider.notifier).add(widget.data);
      ref.read(isAddedProvider.notifier).change(true);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, "Added to your list"));
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, "Unable to Add", true));
      debugPrint("$err");
    } finally {
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 1),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.showDetails)
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
                          backgroundColor:
                              MaterialStateProperty.all(kActionColor),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    const Text(
                      "Add to list",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(flex: widget.showDetails ? 2 : 1),
                  ],
                ),
                const Gap(),

                // Watching Status
                const Text(
                  "Status",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Gap(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedStatus = Status.watching;
                        });
                      },
                      child: Tooltip(
                        message: "Watching",
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _selectedStatus == Status.watching
                              ? (size.width / 1.4) - kDefaultPadding * 2
                              : (size.width / 3) - kDefaultPadding * 2,
                          padding: const EdgeInsets.all(kDefaultPadding / 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: _selectedStatus == Status.watching
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
                                  children: <Widget>[
                                    Gap(
                                      axis: Axis.horizontal,
                                    ),
                                    Text(
                                      "Watching",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                crossFadeState:
                                    _selectedStatus == Status.watching
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
                        setState(() {
                          _selectedStatus = Status.planToWatch;
                          _textController.text = '0';
                        });
                      },
                      child: Tooltip(
                        message: "Plan to Watch",
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _selectedStatus == Status.planToWatch
                              ? (size.width / 1.4) - kDefaultPadding * 2
                              : (size.width / 3) - kDefaultPadding * 2,
                          padding: const EdgeInsets.all(kDefaultPadding / 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: _selectedStatus == Status.planToWatch
                                ? kActionColor
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_to_queue,
                                  color: Colors.white),
                              AnimatedCrossFade(
                                firstChild: const SizedBox(),
                                secondChild: const Row(
                                  children: <Widget>[
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
                                    _selectedStatus == Status.planToWatch
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Episodes",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.data.episodes,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Gap(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_textController.text == "1" ||
                            _textController.text == "0") {
                          return;
                        }

                        _textController.text =
                            (int.parse(_textController.text) - 1).toString();
                      },
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(
                      axis: Axis.horizontal,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kActionColor,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kActionColor,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          if (widget.data.episodes == "N/A") {
                            return;
                          }

                          final intValue = int.tryParse(value) ?? 0;
                          final currenValue =
                              int.parse(widget.data.episodes.split(" ")[0]);

                          if (intValue > currenValue) {
                            _textController.text = "0";
                          }
                        },
                      ),
                    ),
                    const Gap(
                      axis: Axis.horizontal,
                    ),
                    IconButton(
                      onPressed: () {
                        if (_textController.text ==
                            widget.data.episodes.split(" ")[0]) {
                          return;
                        }

                        if (_selectedStatus == Status.planToWatch) {
                          setState(() {
                            _selectedStatus = Status.watching;
                          });
                        }

                        _textController.text =
                            (int.parse(_textController.text) + 1).toString();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Gap(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            side: const BorderSide(color: kActionColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding,
                              vertical: kDefaultPadding / 2),
                        ),
                      ),
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: const Text("Close"),
                    ),
                    const Gap(
                      axis: Axis.horizontal,
                    ),
                    TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kActionColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding,
                            vertical: kDefaultPadding / 2,
                          ),
                        ),
                      ),
                      icon: _loading
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            )
                          : const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                      onPressed: _save,
                      label: Text(
                        _loading ? "Saving.." : "Save",
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
