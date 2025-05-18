// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectNameHash() => r'905f96f7bce48d80cc7aaddee32d4144f556eb29';

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

/// See also [projectName].
@ProviderFor(projectName)
const projectNameProvider = ProjectNameFamily();

/// See also [projectName].
class ProjectNameFamily extends Family<AsyncValue<String>> {
  /// See also [projectName].
  const ProjectNameFamily();

  /// See also [projectName].
  ProjectNameProvider call(
    String projectId,
  ) {
    return ProjectNameProvider(
      projectId,
    );
  }

  @override
  ProjectNameProvider getProviderOverride(
    covariant ProjectNameProvider provider,
  ) {
    return call(
      provider.projectId,
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
  String? get name => r'projectNameProvider';
}

/// See also [projectName].
class ProjectNameProvider extends AutoDisposeFutureProvider<String> {
  /// See also [projectName].
  ProjectNameProvider(
    String projectId,
  ) : this._internal(
          (ref) => projectName(
            ref as ProjectNameRef,
            projectId,
          ),
          from: projectNameProvider,
          name: r'projectNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectNameHash,
          dependencies: ProjectNameFamily._dependencies,
          allTransitiveDependencies:
              ProjectNameFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ProjectNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Override overrideWith(
    FutureOr<String> Function(ProjectNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectNameProvider._internal(
        (ref) => create(ref as ProjectNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _ProjectNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectNameProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectNameRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectNameProviderElement
    extends AutoDisposeFutureProviderElement<String> with ProjectNameRef {
  _ProjectNameProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectNameProvider).projectId;
}

String _$projectsIdsPHash() => r'439793c0b3c9bd71ddd1b9efd9305da0e4d54729';

/// See also [ProjectsIdsP].
@ProviderFor(ProjectsIdsP)
final projectsIdsPProvider =
    AutoDisposeStreamNotifierProvider<ProjectsIdsP, IList<String>>.internal(
  ProjectsIdsP.new,
  name: r'projectsIdsPProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$projectsIdsPHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProjectsIdsP = AutoDisposeStreamNotifier<IList<String>>;
String _$projectPHash() => r'3c1dfcce992acb7a92bdc59db9276ee0380d3396';

abstract class _$ProjectP
    extends BuildlessAutoDisposeStreamNotifier<ProjectData> {
  late final String projectId;

  Stream<ProjectData> build(
    String projectId,
  );
}

/// See also [ProjectP].
@ProviderFor(ProjectP)
const projectPProvider = ProjectPFamily();

/// See also [ProjectP].
class ProjectPFamily extends Family<AsyncValue<ProjectData>> {
  /// See also [ProjectP].
  const ProjectPFamily();

  /// See also [ProjectP].
  ProjectPProvider call(
    String projectId,
  ) {
    return ProjectPProvider(
      projectId,
    );
  }

  @override
  ProjectPProvider getProviderOverride(
    covariant ProjectPProvider provider,
  ) {
    return call(
      provider.projectId,
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
  String? get name => r'projectPProvider';
}

/// See also [ProjectP].
class ProjectPProvider
    extends AutoDisposeStreamNotifierProviderImpl<ProjectP, ProjectData> {
  /// See also [ProjectP].
  ProjectPProvider(
    String projectId,
  ) : this._internal(
          () => ProjectP()..projectId = projectId,
          from: projectPProvider,
          name: r'projectPProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectPHash,
          dependencies: ProjectPFamily._dependencies,
          allTransitiveDependencies: ProjectPFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ProjectPProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Stream<ProjectData> runNotifierBuild(
    covariant ProjectP notifier,
  ) {
    return notifier.build(
      projectId,
    );
  }

  @override
  Override overrideWith(ProjectP Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProjectPProvider._internal(
        () => create()..projectId = projectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<ProjectP, ProjectData>
      createElement() {
    return _ProjectPProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectPProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectPRef on AutoDisposeStreamNotifierProviderRef<ProjectData> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectPProviderElement
    extends AutoDisposeStreamNotifierProviderElement<ProjectP, ProjectData>
    with ProjectPRef {
  _ProjectPProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectPProvider).projectId;
}

String _$projectTaskIdsPHash() => r'e8a6006a56239d8112f05f152b1f00884cef4c19';

abstract class _$ProjectTaskIdsP
    extends BuildlessAutoDisposeStreamNotifier<IList<String>> {
  late final String projectId;

  Stream<IList<String>> build(
    String projectId,
  );
}

/// See also [ProjectTaskIdsP].
@ProviderFor(ProjectTaskIdsP)
const projectTaskIdsPProvider = ProjectTaskIdsPFamily();

/// See also [ProjectTaskIdsP].
class ProjectTaskIdsPFamily extends Family<AsyncValue<IList<String>>> {
  /// See also [ProjectTaskIdsP].
  const ProjectTaskIdsPFamily();

  /// See also [ProjectTaskIdsP].
  ProjectTaskIdsPProvider call(
    String projectId,
  ) {
    return ProjectTaskIdsPProvider(
      projectId,
    );
  }

  @override
  ProjectTaskIdsPProvider getProviderOverride(
    covariant ProjectTaskIdsPProvider provider,
  ) {
    return call(
      provider.projectId,
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
  String? get name => r'projectTaskIdsPProvider';
}

/// See also [ProjectTaskIdsP].
class ProjectTaskIdsPProvider extends AutoDisposeStreamNotifierProviderImpl<
    ProjectTaskIdsP, IList<String>> {
  /// See also [ProjectTaskIdsP].
  ProjectTaskIdsPProvider(
    String projectId,
  ) : this._internal(
          () => ProjectTaskIdsP()..projectId = projectId,
          from: projectTaskIdsPProvider,
          name: r'projectTaskIdsPProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectTaskIdsPHash,
          dependencies: ProjectTaskIdsPFamily._dependencies,
          allTransitiveDependencies:
              ProjectTaskIdsPFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ProjectTaskIdsPProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Stream<IList<String>> runNotifierBuild(
    covariant ProjectTaskIdsP notifier,
  ) {
    return notifier.build(
      projectId,
    );
  }

  @override
  Override overrideWith(ProjectTaskIdsP Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProjectTaskIdsPProvider._internal(
        () => create()..projectId = projectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<ProjectTaskIdsP, IList<String>>
      createElement() {
    return _ProjectTaskIdsPProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectTaskIdsPProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectTaskIdsPRef
    on AutoDisposeStreamNotifierProviderRef<IList<String>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectTaskIdsPProviderElement
    extends AutoDisposeStreamNotifierProviderElement<ProjectTaskIdsP,
        IList<String>> with ProjectTaskIdsPRef {
  _ProjectTaskIdsPProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectTaskIdsPProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
