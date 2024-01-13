// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_anime.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchScheduleAnimeHash() =>
    r'624c59e228ea34267e65a6bd1f932a4f66fefb06';

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

typedef FetchScheduleAnimeRef
    = AutoDisposeFutureProviderRef<List<ScheduleAnime>>;

/// See also [fetchScheduleAnime].
@ProviderFor(fetchScheduleAnime)
const fetchScheduleAnimeProvider = FetchScheduleAnimeFamily();

/// See also [fetchScheduleAnime].
class FetchScheduleAnimeFamily extends Family<AsyncValue<List<ScheduleAnime>>> {
  /// See also [fetchScheduleAnime].
  const FetchScheduleAnimeFamily();

  /// See also [fetchScheduleAnime].
  FetchScheduleAnimeProvider call({
    required DateTime date,
  }) {
    return FetchScheduleAnimeProvider(
      date: date,
    );
  }

  @override
  FetchScheduleAnimeProvider getProviderOverride(
    covariant FetchScheduleAnimeProvider provider,
  ) {
    return call(
      date: provider.date,
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
  String? get name => r'fetchScheduleAnimeProvider';
}

/// See also [fetchScheduleAnime].
class FetchScheduleAnimeProvider
    extends AutoDisposeFutureProvider<List<ScheduleAnime>> {
  /// See also [fetchScheduleAnime].
  FetchScheduleAnimeProvider({
    required this.date,
  }) : super.internal(
          (ref) => fetchScheduleAnime(
            ref,
            date: date,
          ),
          from: fetchScheduleAnimeProvider,
          name: r'fetchScheduleAnimeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchScheduleAnimeHash,
          dependencies: FetchScheduleAnimeFamily._dependencies,
          allTransitiveDependencies:
              FetchScheduleAnimeFamily._allTransitiveDependencies,
        );

  final DateTime date;

  @override
  bool operator ==(Object other) {
    return other is FetchScheduleAnimeProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
