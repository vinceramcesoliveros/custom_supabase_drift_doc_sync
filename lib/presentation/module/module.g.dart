// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'603345afefa09b9d86e039db4d0e32a486e84ebd';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$authStateHash() => r'686f1be7c4c7bfd58ec61d6f7bfa5e890a824483';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = StreamProvider<AuthState>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateRef = StreamProviderRef<AuthState>;
String _$appRouterHash() => r'0209259634b624c16137716d9d91dee62e47db06';

/// See also [appRouter].
@ProviderFor(appRouter)
final appRouterProvider = AutoDisposeProvider<AppRouter>.internal(
  appRouter,
  name: r'appRouterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appRouterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppRouterRef = AutoDisposeProviderRef<AppRouter>;
String _$supabaseHash() => r'b58c1688cb1a27c90ca42f0ef0ff347ab226f96c';

/// See also [supabase].
@ProviderFor(supabase)
final supabaseProvider = AutoDisposeProvider<SupabaseClient>.internal(
  supabase,
  name: r'supabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$supabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SupabaseRef = AutoDisposeProviderRef<SupabaseClient>;
String _$isarHash() => r'1f4320c67e502585ab06a41bde3a44b46e4ed97f';

/// See also [isar].
@ProviderFor(isar)
final isarProvider = AutoDisposeProvider<Isar>.internal(
  isar,
  name: r'isarProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsarRef = AutoDisposeProviderRef<Isar>;
String _$sessionPHash() => r'aad71147736bb676742b5bec9c77503307b2a59a';

/// See also [SessionP].
@ProviderFor(SessionP)
final sessionPProvider = NotifierProvider<SessionP, Option<Session>>.internal(
  SessionP.new,
  name: r'sessionPProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sessionPHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SessionP = Notifier<Option<Session>>;
String _$syncMangerPHash() => r'3b2500f68c7a85ab06b94fb1b274a5af44d6b7f8';

/// See also [SyncMangerP].
@ProviderFor(SyncMangerP)
final syncMangerPProvider =
    AutoDisposeNotifierProvider<SyncMangerP, SyncManagerS>.internal(
  SyncMangerP.new,
  name: r'syncMangerPProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncMangerPHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SyncMangerP = AutoDisposeNotifier<SyncManagerS>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
