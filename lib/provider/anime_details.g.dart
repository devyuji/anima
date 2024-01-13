// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_details.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchDetailsHash() => r'19027c6954bcdce3dc4b73dc6aa1cdac3e5e4602';

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

typedef FetchDetailsRef = AutoDisposeFutureProviderRef<Details>;

/// See also [fetchDetails].
@ProviderFor(fetchDetails)
const fetchDetailsProvider = FetchDetailsFamily();

/// See also [fetchDetails].
class FetchDetailsFamily extends Family<AsyncValue<Details>> {
  /// See also [fetchDetails].
  const FetchDetailsFamily();

  /// See also [fetchDetails].
  FetchDetailsProvider call({
    required int id,
  }) {
    return FetchDetailsProvider(
      id: id,
    );
  }

  @override
  FetchDetailsProvider getProviderOverride(
    covariant FetchDetailsProvider provider,
  ) {
    return call(
      id: provider.id,
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
  String? get name => r'fetchDetailsProvider';
}

/// See also [fetchDetails].
class FetchDetailsProvider extends AutoDisposeFutureProvider<Details> {
  /// See also [fetchDetails].
  FetchDetailsProvider({
    required this.id,
  }) : super.internal(
          (ref) => fetchDetails(
            ref,
            id: id,
          ),
          from: fetchDetailsProvider,
          name: r'fetchDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchDetailsHash,
          dependencies: FetchDetailsFamily._dependencies,
          allTransitiveDependencies:
              FetchDetailsFamily._allTransitiveDependencies,
        );

  final int id;

  @override
  bool operator ==(Object other) {
    return other is FetchDetailsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$isAddedHash() => r'e94de848e8c15f5b1cc90272ad495fbfd31794a1';

/// See also [IsAdded].
@ProviderFor(IsAdded)
final isAddedProvider = AutoDisposeNotifierProvider<IsAdded, bool>.internal(
  IsAdded.new,
  name: r'isAddedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isAddedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsAdded = AutoDisposeNotifier<bool>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
