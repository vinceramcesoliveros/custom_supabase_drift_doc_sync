// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$docPHash() => r'bfe3c8819bd88e6e07c9980079edb591e59b5d1b';

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

abstract class _$DocP extends BuildlessAutoDisposeAsyncNotifier<EditorState> {
  late final String taskId;

  FutureOr<EditorState> build(
    String taskId,
  );
}

/// See also [DocP].
@ProviderFor(DocP)
const docPProvider = DocPFamily();

/// See also [DocP].
class DocPFamily extends Family<AsyncValue<EditorState>> {
  /// See also [DocP].
  const DocPFamily();

  /// See also [DocP].
  DocPProvider call(
    String taskId,
  ) {
    return DocPProvider(
      taskId,
    );
  }

  @override
  DocPProvider getProviderOverride(
    covariant DocPProvider provider,
  ) {
    return call(
      provider.taskId,
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
  String? get name => r'docPProvider';
}

/// See also [DocP].
class DocPProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DocP, EditorState> {
  /// See also [DocP].
  DocPProvider(
    String taskId,
  ) : this._internal(
          () => DocP()..taskId = taskId,
          from: docPProvider,
          name: r'docPProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$docPHash,
          dependencies: DocPFamily._dependencies,
          allTransitiveDependencies: DocPFamily._allTransitiveDependencies,
          taskId: taskId,
        );

  DocPProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
  }) : super.internal();

  final String taskId;

  @override
  FutureOr<EditorState> runNotifierBuild(
    covariant DocP notifier,
  ) {
    return notifier.build(
      taskId,
    );
  }

  @override
  Override overrideWith(DocP Function() create) {
    return ProviderOverride(
      origin: this,
      override: DocPProvider._internal(
        () => create()..taskId = taskId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DocP, EditorState> createElement() {
    return _DocPProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DocPProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DocPRef on AutoDisposeAsyncNotifierProviderRef<EditorState> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _DocPProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DocP, EditorState>
    with DocPRef {
  _DocPProviderElement(super.provider);

  @override
  String get taskId => (origin as DocPProvider).taskId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
