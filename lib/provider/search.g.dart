// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchSearchResultHash() => r'8bf3c7f63fd40682f1b2f84f28491b2a9d0ac4dc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef FetchSearchResultRef = AutoDisposeFutureProviderRef<List<Search>>;

/// See also [fetchSearchResult].
@ProviderFor(fetchSearchResult)
const fetchSearchResultProvider = FetchSearchResultFamily();

/// See also [fetchSearchResult].
class FetchSearchResultFamily extends Family<AsyncValue<List<Search>>> {
  /// See also [fetchSearchResult].
  const FetchSearchResultFamily();

  /// See also [fetchSearchResult].
  FetchSearchResultProvider call({
    required int page,
  }) {
    return FetchSearchResultProvider(
      page: page,
    );
  }

  @override
  FetchSearchResultProvider getProviderOverride(
    covariant FetchSearchResultProvider provider,
  ) {
    return call(
      page: provider.page,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchSearchResultProvider';
}

/// See also [fetchSearchResult].
class FetchSearchResultProvider
    extends AutoDisposeFutureProvider<List<Search>> {
  /// See also [fetchSearchResult].
  FetchSearchResultProvider({
    required this.page,
  }) : super.internal(
          (ref) => fetchSearchResult(
            ref,
            page: page,
          ),
          from: fetchSearchResultProvider,
          name: r'fetchSearchResultProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchSearchResultHash,
          dependencies: FetchSearchResultFamily._dependencies,
          allTransitiveDependencies:
              FetchSearchResultFamily._allTransitiveDependencies,
        );

  final int page;

  @override
  bool operator ==(Object other) {
    return other is FetchSearchResultProvider && other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$searchValueHash() => r'70a1dcdfed651458973b5a6a958c337f53b25054';

/// See also [SearchValue].
@ProviderFor(SearchValue)
final searchValueProvider =
    AutoDisposeNotifierProvider<SearchValue, String>.internal(
  SearchValue.new,
  name: r'searchValueProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchValueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchValue = AutoDisposeNotifier<String>;
String _$searchHistoryListHash() => r'a2912cd6a791f0f51e78b613099cbcfdd95c754e';

/// See also [SearchHistoryList].
@ProviderFor(SearchHistoryList)
final searchHistoryListProvider = AutoDisposeAsyncNotifierProvider<
    SearchHistoryList, List<SearchHistory>>.internal(
  SearchHistoryList.new,
  name: r'searchHistoryListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchHistoryListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchHistoryList = AutoDisposeAsyncNotifier<List<SearchHistory>>;
String _$filterSearchHash() => r'46c5c65b2cb01cb60e8dc727f2222cc2f882d548';

/// See also [FilterSearch].
@ProviderFor(FilterSearch)
final filterSearchProvider =
    AutoDisposeNotifierProvider<FilterSearch, SearchFilter>.internal(
  FilterSearch.new,
  name: r'filterSearchProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$filterSearchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FilterSearch = AutoDisposeNotifier<SearchFilter>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
