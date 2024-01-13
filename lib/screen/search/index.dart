import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:anima/widgets/gap.dart';
import 'package:anima/utils/custom_route_animation.dart';
import 'package:anima/constraint.dart';
import 'package:anima/model/search_history.dart';
import 'package:anima/provider/search.dart';
import 'package:anima/screen/search/search_result.dart';
import 'package:anima/widgets/loading.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.pop = false});

  final bool pop;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _textEdittingController;
  late final FocusNode _textFieldFocusNode;

  late final ScrollController _scrollController;
  bool _showSearchButton = false;

  @override
  void initState() {
    super.initState();
    final defaultValue = ref.read(searchValueProvider);
    _textEdittingController = TextEditingController(text: defaultValue);
    _textFieldFocusNode = FocusNode();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 250) {
            _showSearchButton = true;
          } else {
            _showSearchButton = false;
          }
        });
      });

    _textEdittingController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textEdittingController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _search(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }

    ref.read(searchValueProvider.notifier).change(value);

    ref
        .read(searchHistoryListProvider.notifier)
        .add(SearchHistory(text: value));

    Navigator.push(
      context,
      customRouteAnimation(
        const SearchResultScreen(),
      ),
    );
  }

  void _deleteDialoge(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Remove from search history?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              ref.read(searchHistoryListProvider.notifier).remove(id);
              Navigator.pop(context);
            },
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(searchHistoryListProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverAppBar(
            toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight!,
            title: const Text("Search Anime"),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(kDefaultPadding),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    focusNode: _textFieldFocusNode,
                    controller: _textEdittingController,
                    decoration: InputDecoration(
                      fillColor: kPrimaryColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Naruto, One Piece, Demon Slayer",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                      ),
                      suffixIcon: Visibility(
                        visible: _textEdittingController.text.isNotEmpty,
                        child: IconButton(
                          onPressed: () {
                            _textEdittingController.text = "";
                            _textFieldFocusNode.requestFocus();
                          },
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                    style: Theme.of(context)
                        .inputDecorationTheme
                        .hintStyle!
                        .copyWith(
                          color: Colors.white,
                        ),
                    onSubmitted: _search,
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.all(kDefaultPadding),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Recent Search",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          history.when(
            data: (data) {
              if (data.isEmpty) {
                return SliverPadding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/images/no_result.svg",
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        const Gap(),
                        const Text(
                          "You haven't search anything!",
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
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: kDefaultPadding / 2),
                        child: ListTile(
                          onTap: () {
                            _textEdittingController.text = data[index].text;
                            _textFieldFocusNode.requestFocus();
                          },
                          onLongPress: () => _deleteDialoge(data[index].id!),
                          leading: const Icon(Icons.history),
                          title: Text(data[index].text),
                          trailing: const Icon(Icons.north_east),
                        ),
                      );
                    },
                    childCount: data.length,
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
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    const Gap(),
                    const Text(
                      "Something went wrong!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
      floatingActionButton: _showSearchButton
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 750),
                    curve: Curves.linear);
                _textFieldFocusNode.requestFocus();
              },
              backgroundColor: kActionColor,
              child: const Icon(Icons.search),
            )
          : null,
    );
  }
}
