import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:anima/provider/schedule_anime.dart';
import 'package:anima/widgets/custom_modal_bottom_sheet.dart';
import 'package:anima/widgets/loading.dart';
import 'package:anima/widgets/scroll_indicator.dart';
import 'package:anima/constraint.dart';
import 'package:anima/widgets/back.dart';
import 'package:anima/widgets/gap.dart';

class UpcommingScreen extends ConsumerStatefulWidget {
  const UpcommingScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _UpcommingScreenState();
}

class _UpcommingScreenState extends ConsumerState<UpcommingScreen> {
  late final _dates = <DateTime>[];
  DateTime _now = DateTime.now();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _now = DateTime(_now.year, _now.month, _now.day);

    for (int i = 0; i < 7; i++) {
      _dates.add(_now.add(Duration(days: (i + 1) - _now.weekday)));
    }

    _selectedDate = _now;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showAlert() {
    customModalBottomSheet(
      context,
      (_) => const Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Wrap(
          children: [
            Center(child: ScrollIndicator()),
            SizedBox(
              width: double.infinity,
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                "Displaying time accurately can be challenging due to varying time zones and platforms.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _update(DateTime d) {
    setState(() {
      _selectedDate = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(fetchScheduleAnimeProvider(date: _selectedDate));

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          backgroundColor: kPrimaryColor,
          color: kActionColor,
          onRefresh: () => ref
              .refresh(FetchScheduleAnimeProvider(date: _selectedDate).future),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                leading: backButton(context),
                centerTitle: false,
                toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight!,
                title: Text(
                    "${DateFormat('MMM').format(_selectedDate)}, ${_selectedDate.day}"),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = _now;
                      });
                    },
                    child: const Text(
                      "Today",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showAlert,
                    icon: const Icon(Icons.info),
                  ),
                ],
              ),

              // current week dates
              SliverPadding(
                padding: const EdgeInsets.all(kDefaultPadding),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: DayHeader(
                    dates: _dates,
                    now: _now,
                    ref: ref,
                    selectedDate: _selectedDate,
                    update: _update,
                  ),
                ),
              ),

              data.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text("No found!"),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final time = DateTime.fromMillisecondsSinceEpoch(
                                data[index].time * 1000)
                            .toLocal();

                        // final weekDay = DateFormat('EEEE').format(time);

                        return Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius),
                                  child: Image.memory(data[index].image),
                                ),
                              ),
                              const Gap(
                                axis: Axis.horizontal,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Align(
                                    //   alignment: Alignment.topRight,
                                    //   child: Container(
                                    //     padding: const EdgeInsets.all(
                                    //         kDefaultPadding / 2),
                                    //     decoration: BoxDecoration(
                                    //       color: kPrimaryColor,
                                    //       borderRadius: BorderRadius.circular(
                                    //           kBorderRadius),
                                    //     ),
                                    //     child: Text(
                                    //       "${time.day}",
                                    //       style: const TextStyle(
                                    //         fontSize: 18,
                                    //         fontWeight: FontWeight.w600,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // const Gap(),
                                    Text(
                                      data[index].title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Gap(size: 5),
                                    Text(
                                      "Episode ${data[index].episode}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Gap(size: 5),
                                    Text(
                                      "${time.hour} : ${time.minute}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: data.length,
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
                        const Text("Try again later"),
                      ],
                    ),
                  ),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(kDefaultPadding),
                    child: Center(
                      child: RepaintBoundary(
                        child: Loading(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DayHeader extends SliverPersistentHeaderDelegate {
  const DayHeader({
    required this.ref,
    required this.dates,
    required this.selectedDate,
    required this.now,
    required this.update,
  });

  final WidgetRef ref;
  final double maxHeight = 65;
  final List<DateTime> dates;
  final DateTime selectedDate;
  final DateTime now;
  final ValueChanged<DateTime> update;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: kBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final date in dates)
            GestureDetector(
              onTap: () {
                update(date);
              },
              child: Column(
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                  const Gap(size: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: selectedDate == date
                          ? kActionColor
                          : date == now
                              ? Colors.white
                              : null,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    width: (MediaQuery.of(context).size.width / 7) -
                        kDefaultPadding,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: selectedDate == date
                            ? Colors.white
                            : date == now
                                ? Colors.black
                                : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
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
