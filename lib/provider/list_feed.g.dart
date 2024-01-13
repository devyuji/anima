// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_feed.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filterListHash() => r'b8f27d6521f56e7f04b49a378a59f1b3044cb716';

/// See also [filterList].
@ProviderFor(filterList)
final filterListProvider = AutoDisposeFutureProvider<List<Anime>>.internal(
  filterList,
  name: r'filterListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$filterListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilterListRef = AutoDisposeFutureProviderRef<List<Anime>>;
String _$listFeedHash() => r'80c02af2d387509367bb9cef338ba25c9eb32ed4';

/// See also [ListFeed].
@ProviderFor(ListFeed)
final listFeedProvider =
    AutoDisposeAsyncNotifierProvider<ListFeed, List<Anime>>.internal(
  ListFeed.new,
  name: r'listFeedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$listFeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ListFeed = AutoDisposeAsyncNotifier<List<Anime>>;
String _$filterAnimeHash() => r'e209807568d17762a570e80d099bee2a4ab1583e';

/// See also [FilterAnime].
@ProviderFor(FilterAnime)
final filterAnimeProvider =
    AutoDisposeNotifierProvider<FilterAnime, Filter>.internal(
  FilterAnime.new,
  name: r'filterAnimeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$filterAnimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FilterAnime = AutoDisposeNotifier<Filter>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
