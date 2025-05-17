// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskNameHash() => r'1e48d1b38ee8afed558cfa8eddd7d771cd6fa914';

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

/// See also [taskName].
@ProviderFor(taskName)
const taskNameProvider = TaskNameFamily();

/// See also [taskName].
class TaskNameFamily extends Family<AsyncValue<String>> {
  /// See also [taskName].
  const TaskNameFamily();

  /// See also [taskName].
  TaskNameProvider call(
    String taskId,
  ) {
    return TaskNameProvider(
      taskId,
    );
  }

  @override
  TaskNameProvider getProviderOverride(
    covariant TaskNameProvider provider,
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
  String? get name => r'taskNameProvider';
}

/// See also [taskName].
class TaskNameProvider extends AutoDisposeFutureProvider<String> {
  /// See also [taskName].
  TaskNameProvider(
    String taskId,
  ) : this._internal(
          (ref) => taskName(
            ref as TaskNameRef,
            taskId,
          ),
          from: taskNameProvider,
          name: r'taskNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskNameHash,
          dependencies: TaskNameFamily._dependencies,
          allTransitiveDependencies: TaskNameFamily._allTransitiveDependencies,
          taskId: taskId,
        );

  TaskNameProvider._internal(
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
  Override overrideWith(
    FutureOr<String> Function(TaskNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskNameProvider._internal(
        (ref) => create(ref as TaskNameRef),
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
  AutoDisposeFutureProviderElement<String> createElement() {
    return _TaskNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskNameProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TaskNameRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _TaskNameProviderElement extends AutoDisposeFutureProviderElement<String>
    with TaskNameRef {
  _TaskNameProviderElement(super.provider);

  @override
  String get taskId => (origin as TaskNameProvider).taskId;
}

String _$taskPHash() => r'c418c8dde865dc3898342addc2584b44df45a01a';

abstract class _$TaskP extends BuildlessAutoDisposeStreamNotifier<TaskData> {
  late final String taskId;

  Stream<TaskData> build(
    String taskId,
  );
}

/// See also [TaskP].
@ProviderFor(TaskP)
const taskPProvider = TaskPFamily();

/// See also [TaskP].
class TaskPFamily extends Family<AsyncValue<TaskData>> {
  /// See also [TaskP].
  const TaskPFamily();

  /// See also [TaskP].
  TaskPProvider call(
    String taskId,
  ) {
    return TaskPProvider(
      taskId,
    );
  }

  @override
  TaskPProvider getProviderOverride(
    covariant TaskPProvider provider,
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
  String? get name => r'taskPProvider';
}

/// See also [TaskP].
class TaskPProvider
    extends AutoDisposeStreamNotifierProviderImpl<TaskP, TaskData> {
  /// See also [TaskP].
  TaskPProvider(
    String taskId,
  ) : this._internal(
          () => TaskP()..taskId = taskId,
          from: taskPProvider,
          name: r'taskPProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskPHash,
          dependencies: TaskPFamily._dependencies,
          allTransitiveDependencies: TaskPFamily._allTransitiveDependencies,
          taskId: taskId,
        );

  TaskPProvider._internal(
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
  Stream<TaskData> runNotifierBuild(
    covariant TaskP notifier,
  ) {
    return notifier.build(
      taskId,
    );
  }

  @override
  Override overrideWith(TaskP Function() create) {
    return ProviderOverride(
      origin: this,
      override: TaskPProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<TaskP, TaskData> createElement() {
    return _TaskPProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskPProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TaskPRef on AutoDisposeStreamNotifierProviderRef<TaskData> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _TaskPProviderElement
    extends AutoDisposeStreamNotifierProviderElement<TaskP, TaskData>
    with TaskPRef {
  _TaskPProviderElement(super.provider);

  @override
  String get taskId => (origin as TaskPProvider).taskId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
