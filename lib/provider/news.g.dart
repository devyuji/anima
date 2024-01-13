// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchNewsHash() => r'b5250b6a2e15418170e5f321b1924c40e3cf7e46';

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

typedef FetchNewsRef = AutoDisposeFutureProviderRef<List<News>>;

/// See also [fetchNews].
@ProviderFor(fetchNews)
const fetchNewsProvider = FetchNewsFamily();

/// See also [fetchNews].
class FetchNewsFamily extends Family<AsyncValue<List<News>>> {
  /// See also [fetchNews].
  const FetchNewsFamily();

  /// See also [fetchNews].
  FetchNewsProvider call({
    required int page,
  }) {
    return FetchNewsProvider(
      page: page,
    );
  }

  @override
  FetchNewsProvider getProviderOverride(
    covariant FetchNewsProvider provider,
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
  String? get name => r'fetchNewsProvider';
}

/// See also [fetchNews].
class FetchNewsProvider extends AutoDisposeFutureProvider<List<News>> {
  /// See also [fetchNews].
  FetchNewsProvider({
    required this.page,
  }) : super.internal(
          (ref) => fetchNews(
            ref,
            page: page,
          ),
          from: fetchNewsProvider,
          name: r'fetchNewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchNewsHash,
          dependencies: FetchNewsFamily._dependencies,
          allTransitiveDependencies: FetchNewsFamily._allTransitiveDependencies,
        );

  final int page;

  @override
  bool operator ==(Object other) {
    return other is FetchNewsProvider && other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
