# Custom Drift Synchronization Example

This project showcases two things:
- How can you easily sync your data (one-user data) across devices that are stored using Drift DB?
- Showcase of synchronization of appflowy editor content across devices with handling of merge conflicts using appflowy_editor_sync_plugin 

## Demo

Example of how this works in the browser. But the same applies for native platforms. The browser only has some workarounds viz: `database.dart`, `tab_separated_shared_preferences.dart`:


https://github.com/user-attachments/assets/274e50de-ac70-42b1-9a43-083a8f0db7ac


**Notes:**
The demo is slightly longer because it is a live demonstration and involves turning the Wi-Fi on and off. This same demo functions well on all other Flutter platforms and Wear OS if properly configured.

## The synchronization is achieved by:
### Client
- Annotation drift cases and providing special variables

```dart
@customSync // 1. Add customSync annotation
class Task extends Table {
  static String get serverTableName => "public.task"; // 2. specify server db table name with schema

  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  @JsonKey('created_at') // 3. Provide timestamp attributes a
  DateTimeColumn get createdAt => dateTime()();
  @JsonKey('updated_at') // 3. Provide timestamp attributes b
  DateTimeColumn get updatedAt => dateTime()();
  @JsonKey('deleted_at') // 3. Provide timestamp attributes c
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get name => text()();
  

  // 4. Specify the isRemote attribute
  BoolColumn get isRemote => boolean().withDefault(const Constant(false))();

  @JsonKey('project_id')
  TextColumn get projectId => text()();
  @JsonKey('user_id')
  TextColumn get userId => text()();

  @override
  Set<Column> get primaryKey => {id};
}
```

Define `SyncManager`
- `SyncManager` combines data from annotated classes and generates code that can be used with  `WatermelonDB` styled server DB functions.
```dart
part 'sync_manager.sync.dart';
// Specify tables to sync in - IN THE ORDER OF THEIR DEPENDENCIES
@SyncManager(classes: [Task, Project, Docup])
class SyncClass {
  const SyncClass();

  Future<void> sync(Map<String, dynamic> changes, AppDatabase db) =>
      _$SyncClassSync(changes, db);
  Future<Map<String, dynamic>> getChanges(
          DateTime lastSyncedAt, AppDatabase db, String currentInstanceId) =>
      _$SyncClassGetChanges(lastSyncedAt, db, currentInstanceId);
  List<String> syncedTables() => _$SyncClassSyncedTables();

  Stream<List<dynamic>> getUpdateStreams(AppDatabase db) =>
      _$SyncClassCombinedStreams(db);
}
```

But provide the tables in the order of dependencies as this will determine the order in which they will be inserted.

Then you can utilize the provided functions, for example like this to communicate with supabase:

```dart
class SyncManagerS {
  final AppDatabase db;
  final SupabaseClient supabase;
  final Isar isar;
  bool _isSyncing = false;
  bool _isLoggedIn = false;
  final String _currentInstanceId = const Uuid().v4();
  bool _extraSyncNeeded = false;
  StreamSubscription? _streamSubscription;

  SyncManagerS({
    required this.db,
    required this.supabase,
    required this.isar,
  }) : super() {
    _checkInitialLoginStatus();
  }

  Future<void> _checkInitialLoginStatus() async {
    // Replace this with your actual logic to check if the user is logged in.
    final session = supabase.auth.currentSession;
    if (session != null) {
      signIn();
    }
  }

  Future<void> _synchronize() async {
    await retry(
      () => _synchronizeBase(),
      retryIf: (e) => e is TimeoutException || e is PostgrestException,
    );
  }

  void _listenOnTheServerUpdates() {
    supabase.channel('db-changes').onAllSyncClassChanges(_currentInstanceId,
            (payload) {
      queueSyncDebounce();
    })
        .subscribe();
  }

  void _startListening() {
    queueSync();
    _listenOnLocalUpdates();
    _listenOnTheServerUpdates();
  }

  void _listenOnLocalUpdates() {
    final combinedStream = const SyncClass().getUpdateStreams(db);
    _streamSubscription = combinedStream.listen((data) async {
      final localChanges = await const SyncClass().getChanges(
          _getLastPulledAt() ?? DateTime(2000), db, _currentInstanceId);
      final isLocalChangesEmpty = localChanges.values.every((element) {
        return (element as Map<String, dynamic>)
            .values
            .every((innerElement) => innerElement.isEmpty);
      });
      if (!isLocalChangesEmpty) {
        queueSyncDebounce();
      }
    });
  }

  void queueSyncDebounce() {
    EasyDebounce.debounce('sync', const Duration(milliseconds: 500), () {
      queueSync();
    });
  }

  Future<void> _synchronizeBase() async {
    final lastPulledAt = _getLastPulledAt();
    final now = DateTime.now();

    // Pull changes from the server
    final pullResponse = await retry(
      () => supabase.rpc('pull_changes', params: {
        'collections': const SyncClass().syncedTables(),
        'last_pulled_at':
            (lastPulledAt ?? DateTime(2000)).toUtc().toIso8601String(),
      }),
      retryIf: (e) => e is TimeoutException || e is PostgrestException,
    );

    final changes = pullResponse['changes'] as Map<String, dynamic>;
    final timestamp = pullResponse['timestamp'] as int;

    // Apply changes to the local database
    await db.transaction(() async {
      await const SyncClass().sync(changes, db);
    });

    // Push local changes to the server
    final localChanges = await const SyncClass()
        .getChanges(lastPulledAt ?? DateTime(2000), db, _currentInstanceId);
    final isLocalChangesEmpty = localChanges.values.every((element) {
      return (element as Map<String, dynamic>)
          .values
          .every((innerElement) => innerElement.isEmpty);
    });
    if (!isLocalChangesEmpty) {
      final res = await supabase.rpc('push_changes', params: {
        '_changes': localChanges,
        'last_pulled_at': lastPulledAt?.toIso8601String(),
      }).timeout(const Duration(seconds: 10));
      _setLastPulledAt(DateTime.parse(res));
    } else {
      _setLastPulledAt(now.subtract(const Duration(minutes: 2)));
    }

    //TODO: Delete synced deletes from local db
  }

  void signIn() {
    _isLoggedIn = true;
    _startListening();
  }

  void signOut() {
    _isLoggedIn = false;
    _stopListening();
  }

  void _stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void queueSync() {
    if (_isSyncing) {
      _extraSyncNeeded = true;
      return;
    }

    _isSyncing = true;
    _synchronize().then((_) {
      _isSyncing = false;
      if (_extraSyncNeeded) {
        _extraSyncNeeded = false;
        queueSync(); // Trigger the extra sync
      }
    }).catchError((error) {
      _isSyncing = false;
      print('Sync failed: $error');
    });
  }

  DateTime? _getLastPulledAt() {
    final syncInfo = isar.syncInfos.get(1);
    return syncInfo?.lastPulledAt;
  }

  void _setLastPulledAt(DateTime timestamp) async {
    isar.write((isar) {
      isar.syncInfos.put(SyncInfo(id: 1, lastPulledAt: timestamp));
    });
  }
}
```




### Server

On the server, you need to define two things:
- RLS rules such as this:
```sql
alter policy "doc_updates_rls"
on "public"."doc_updates"
to authenticated
using (
  (( SELECT auth.uid() AS uid) = user_id)
with check (
  (( SELEC
);
```

In Supabase, these rules are respected inside database functions, so simplify them.

- Database functions:
  - [push_changes](server/db_functions/push_changes.sql)
    - uses [helper functions](server/db_functions/push_changes_helpers.sql)
  - [pull_changes](server/db_functions/pull_changes.sql)


You can copy and paste them into your project if you synchronize data for just one user. The implementation is generic and utilizes RLS rules.


## Run this demo

On Supabase create a project and do these steps:
- Insert tables with RLS from `generate_db.sql`
- Add database functions from:
    - `pull_changes.sql`
    - `push_changes_helpers.sql`
    - `push_changes.sql`

Add to the project .env file with:
```
SUPABASE_URL=https://xxxxsupabase.co
SUPABASE_ANON_KEY=xxxxxx
SUPABASE_STORAGE_BUCKET=xxxx //Not used, but still provide it
```

Run the project :)
