import 'package:anima/constraint.dart';
import 'package:anima/model/search_filter.dart';
import 'package:anima/provider/search.dart';
import 'package:anima/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFilterScreen extends ConsumerStatefulWidget {
  const SearchFilterScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> {
  late SearchFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = ref.read(filterSearchProvider);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _applyFilter() {
    ref.read(filterSearchProvider.notifier).change(_filter);
    Navigator.pop(context);
  }

  void _informationAboutRating() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const AlertDialog(
          contentPadding: EdgeInsets.all(kDefaultPadding),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'G - All ages',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(),
                Text(
                  'PG - Children',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(),
                Text(
                  'PG-13 - Teens 13 or older',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(),
                Text(
                  'R-17+ - Violence & Profanity',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(),
                Text(
                  'R+ - Mild Nudity',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(),
                Text(
                  'Rx - Hentai',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
                Text(
                  "Filter",
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _filter = SearchFilter(
                        swf: false,
                        rating: SearchFilterRating.all,
                        type: SearchFilterType.all,
                        status: SearchFilterStatus.all,
                      );
                    });
                  },
                  icon: const Icon(Icons.restart_alt),
                  tooltip: "Reset",
                ),
              ],
            ),
            const Gap(),
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    "Type",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(size: 10),
                  Wrap(
                    spacing: kDefaultPadding,
                    children: [
                      for (SearchFilterType t in SearchFilterType.values)
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                _filter.type == t ? kActionColor : null),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                side: const BorderSide(color: kActionColor),
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() => _filter.type = t);
                          },
                          child: Text(
                            "${t.name[0].toUpperCase()}${t.name.substring(1)}",
                            style: TextStyle(
                              color: _filter.type == t
                                  ? Colors.white
                                  : kActionColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Gap(),
                  const Text(
                    "Status",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(size: 10),
                  Wrap(
                    spacing: kDefaultPadding,
                    children: [
                      for (SearchFilterStatus s in SearchFilterStatus.values)
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                _filter.status == s ? kActionColor : null),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                side: const BorderSide(color: kActionColor),
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() => _filter.status = s);
                          },
                          child: Text(
                            "${s.name[0].toUpperCase()}${s.name.substring(1)}",
                            style: TextStyle(
                              color: _filter.status == s
                                  ? Colors.white
                                  : kActionColor,
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
                          "Rating",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: _informationAboutRating,
                          icon: const Icon(Icons.info_outlined),
                        )
                      ]),
                  const Gap(size: 10),
                  Wrap(
                    spacing: kDefaultPadding,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              _filter.rating == SearchFilterRating.all
                                  ? kActionColor
                                  : null),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              side: const BorderSide(color: kActionColor),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(
                              () => _filter.rating = SearchFilterRating.all);
                        },
                        child: Text(
                          "All",
                          style: TextStyle(
                            color: _filter.rating == SearchFilterRating.all
                                ? Colors.white
                                : kActionColor,
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              _filter.rating == SearchFilterRating.g
                                  ? kActionColor
                                  : null),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              side: const BorderSide(color: kActionColor),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() => _filter.rating = SearchFilterRating.g);
                        },
                        child: Text(
                          "G",
                          style: TextStyle(
                              color: _filter.rating == SearchFilterRating.g
                                  ? Colors.white
                                  : kActionColor),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              _filter.rating == SearchFilterRating.pg
                                  ? kActionColor
                                  : null),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              side: const BorderSide(color: kActionColor),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(
                              () => _filter.rating = SearchFilterRating.pg);
                        },
                        child: Text(
                          "PG",
                          style: TextStyle(
                            color: _filter.rating == SearchFilterRating.pg
                                ? Colors.white
                                : kActionColor,
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              _filter.rating == SearchFilterRating.pg13
                                  ? kActionColor
                                  : null),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              side: const BorderSide(color: kActionColor),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(
                              () => _filter.rating = SearchFilterRating.pg13);
                        },
                        child: Text(
                          "PG-13",
                          style: TextStyle(
                            color: _filter.rating == SearchFilterRating.pg13
                                ? Colors.white
                                : kActionColor,
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              _filter.rating == SearchFilterRating.r17
                                  ? kActionColor
                                  : null),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              side: const BorderSide(color: kActionColor),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(
                              () => _filter.rating = SearchFilterRating.r17);
                        },
                        child: Text(
                          "R-17+",
                          style: TextStyle(
                              color: _filter.rating == SearchFilterRating.r17
                                  ? Colors.white
                                  : kActionColor),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              _filter.rating == SearchFilterRating.r
                                  ? kActionColor
                                  : null),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              side: const BorderSide(color: kActionColor),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() => _filter.rating = SearchFilterRating.r);
                        },
                        child: Text(
                          "R+",
                          style: TextStyle(
                            color: _filter.rating == SearchFilterRating.r
                                ? Colors.white
                                : kActionColor,
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              _filter.rating == SearchFilterRating.rx
                                  ? kActionColor
                                  : null),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              side: const BorderSide(color: kActionColor),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(
                              () => _filter.rating = SearchFilterRating.rx);
                        },
                        child: Text(
                          "Rx",
                          style: TextStyle(
                            color: _filter.rating == SearchFilterRating.rx
                                ? Colors.white
                                : kActionColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(),
                  SwitchListTile(
                    contentPadding: const EdgeInsets.all(0),
                    activeColor: kActionColor,
                    title: const Text(
                      'Sfw',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    value: _filter.swf,
                    onChanged: (bool value) {
                      setState(() => _filter.swf = value);
                    },
                  ),
                ],
              ),
            ),
            const Gap(),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: const ButtonStyle(
                  padding:
                      MaterialStatePropertyAll(EdgeInsets.all(kDefaultPadding)),
                  backgroundColor: MaterialStatePropertyAll(kActionColor),
                ),
                onPressed: _applyFilter,
                child: const Text(
                  "Apply Filters",
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
  }
}
