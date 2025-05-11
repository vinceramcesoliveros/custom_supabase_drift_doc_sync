// // ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:custom_sync_drift_annotations/annotations.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/rendering.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

import 'package:custom_supabase_drift_sync/core/constant_retry.dart';
import 'package:custom_supabase_drift_sync/core/error_handling.dart';
import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/db/tab_separate_shared_preferences.dart';

// class SyncManagerS {
//   final AppDatabase db;
//   final SupabaseClient supabase;
//   final SharedPreferences basicSharePrefs;
//   late final TabSeparateSharedPreferences sharedPrefs;
//   final bool _isSyncing = false;
//   final bool _isLoggedIn = false;
//   final String _currentInstanceId = const Uuid().v4();
//   final bool _extraSyncNeeded = false;
//   StreamSubscription? _streamSubscription;
//   StreamSubscription<InternetStatus>? _connectionSubscription;
//   Timer? _periodicSyncTimer;

// class SyncManagerS {
//   final AppDatabase db;
//   final SupabaseClient supabase;
//   final SharedPreferences basicSharePrefs;
//   late final TabSeparateSharedPreferences sharedPrefs;
//   bool _isSyncing = false;
//   bool _isLoggedIn = false;
//   final String _currentInstanceId = const Uuid().v4();
//   bool _extraSyncNeeded = false;
//   StreamSubscription? _streamSubscription;
//   StreamSubscription<InternetStatus>? _connectionSubscription;
//   final SyncClass syncClass;
//   SyncManagerS({
//     required this.db,
//     required this.supabase,
//     required this.basicSharePrefs,
//     SyncClass? syncClass,
//   })  : syncClass = syncClass ?? const SyncClass(),
//         super() {
//     _checkInitialLoginStatus();
//     sharedPrefs = TabSeparateSharedPreferences.getInstance(basicSharePrefs);
//   }

// void _startPeriodicSync() {
//   _periodicSyncTimer?.cancel();
//   _periodicSyncTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
//     E.t.debug('Triggering periodic sync (30s interval)');
//     queueSync();
//   });
// }

// Future<void> _checkInitialLoginStatus() async {
//   // Replace this with your actual logic to check if the user is logged in.
//   final session = supabase.auth.currentSession;
//   if (session != null) {
//     signIn();
//   }
// }

//   Future<void> _synchronize() async {
//     await sequenceRetry(
//       () => _synchronizeBase(),
//     );
//   }

//   void _listenOnTheServerUpdates() {
//     supabase.channel('db-changes').onAllSyncClassChanges(_currentInstanceId,
//         (payload) {
//       queueSyncDebounce();
//     }).subscribe((status, err) {
//       debugPrint('Status: $status\n Error: $err');
//     });
//   }

//   void _startListeningOnInternetChanges() {
//     _connectionSubscription =
//         InternetConnection().onStatusChange.listen((InternetStatus status) {
//       switch (status) {
//         case InternetStatus.connected:
//           queueSync();
//           break;
//         case InternetStatus.disconnected:
//           // The internet is now disconnected
//           break;
//       }
//     });
//   }

  // void _startListening() {
  //   queueSync();
  //   _listenOnLocalUpdates();
  //   _listenOnTheServerUpdates();
  //   _startListeningOnInternetChanges();
  //   _startPeriodicSync();
  // }

//   void _listenOnLocalUpdates() {
//     final combinedStream = syncClass.getUpdateStreams(db);
//     _streamSubscription = combinedStream.listen((data) async {
//       final localChanges = await syncClass.getChanges(
//           _getLastPulledAt() ?? DateTime(2000), db, _currentInstanceId);
//       final isLocalChangesEmpty = localChanges.values.every((element) {
//         return (element as Map<String, dynamic>)
//             .values
//             .every((innerElement) => innerElement.isEmpty);
//       });
//       if (!isLocalChangesEmpty) {
//         queueSyncDebounce();
//       }
//     });
//   }

//   void queueSyncDebounce() {
//     EasyDebounce.debounce('sync', const Duration(milliseconds: 100), () {
//       E.t.debug('Debounce trigger sync');
//       queueSync();
//     });
//   }

//   Future<void> _synchronizeBase() async {
//     final lastPulledAt = _getLastPulledAt() ?? DateTime(2000);
//     final now = DateTime.now();

//     // Pull changes from the server
//     final pullResponse = await supabase.rpc('pull_changes', params: {
//       'collections': syncClass.syncedTables(),
//       'last_pulled_at': (lastPulledAt).toUtc().toIso8601String(),
//     });

//     final changes = pullResponse['changes'] as Map<String, dynamic>;

//     // Apply changes to the local database
//     await db.transaction(() async {
//       await syncClass.sync(changes, db);
//     });

//     // Push local changes to the server
//     final localChanges =
//         await syncClass.getChanges(lastPulledAt, db, _currentInstanceId);
//     final isLocalChangesEmpty = localChanges.values.every((element) {
//       return (element as Map<String, dynamic>)
//           .values
//           .every((innerElement) => innerElement.isEmpty);
//     });
//     if (!isLocalChangesEmpty) {
//       try {
//         final res = await supabase.rpc('push_changes', params: {
//           '_changes': localChanges,
//           'last_pulled_at': now.toIso8601String(),
//         }).timeout(const Duration(seconds: 10));
//         await _setLastPulledAt(DateTime.parse(res));
//       } catch (e, st) {
//         E.t.error(e, st);
//         print('Push changes failed: $e');
//       }
//     } else {
//       await _setLastPulledAt(now.subtract(const Duration(minutes: 2)));
//     }

//     //TODO: Delete synced deletes from local db
//   }

//   void signIn() {
//     _isLoggedIn = true;
//     _startListening();
//   }

//   void signOut() async {
//     _isLoggedIn = false;
//     _stopListening();

//     // Clear db
//     await db.transaction(() async {
//       await db.delete(db.docup).go();
//       await db.delete(db.task).go();
//       await db.delete(db.project).go();
//     });

//     // set lastPulledAt = null
//     await sharedPrefs.remove(lastPulledAtKey);
//   }

//   void _stopListening() {
//     _streamSubscription?.cancel();
//     _streamSubscription = null;
//   }

//   void queueSync() {
//     if (_isSyncing) {
//       E.t.debug('Sync already in progress');
//       _extraSyncNeeded = true;
//       return;
//     }

//     _isSyncing = true;
//     E.t.debug('Sync started');
//     _synchronize().then((_) {
//       E.t.debug('Sync completed');
//       _isSyncing = false;

//       if (_extraSyncNeeded) {
//         E.t.debug('Extra sync needed, scheduling first retry in 800ms');
//         _extraSyncNeeded = false;

//         // First retry after 800ms
//         Future.delayed(const Duration(milliseconds: 800), () {
//           if (!_isSyncing) {
//             E.t.debug('Performing first retry sync');
//             queueSync();

//             // Second retry after 4000ms if no other updates triggered a sync
//             Future.delayed(const Duration(milliseconds: 4000), () {
//               if (!_isSyncing && !_extraSyncNeeded) {
//                 E.t.debug('Performing second retry sync');
//                 queueSync();

                // Third retry after another 1000ms if still no updates
  //               Future.delayed(Duration(milliseconds = 8000), () {
  //                 if (!_isSyncing && !_extraSyncNeeded) {
  //                   E.t.debug('Performing third retry sync');
  //                   queueSync();

  //                   // Four retry after another 1000ms if still no updates
  //                   Future.delayed(const Duration(milliseconds: 10000), () {
  //                     if (!_isSyncing && !_extraSyncNeeded) {
  //                       E.t.debug('Performing third retry sync');
  //                       queueSync();
  //                     } else {
  //                       E.t.debug(
  //                           'Skipping four retry, sync already in progress or queued');
  //                     }
  //                   });
  //                 } else {
  //                   E.t.debug(
  //                       'Skipping third retry, sync already in progress or queued');
  //                 }
  //               });
  //             } else {
  //               E.t.debug(
  //                   'Skipping second retry, sync already in progress or queued');
  //             }
  //           });
  //         }
  //       });
  //     }
  //   }).catchError((error, st) {
  //     _isSyncing = false;
  //     E.t.error(error, st);
  //   });
  // }

//   String lastPulledAtKey = 'lastPulledAt';

//   /// Get lastPulledAt using SharedPreferences
//   DateTime? _getLastPulledAt() {
//     final savedLastPulletAt = sharedPrefs.getString(lastPulledAtKey);
//     return savedLastPulletAt != null ? DateTime.parse(savedLastPulletAt) : null;
//   }

//   Future<void> _setLastPulledAt(DateTime timestamp) async {
//     await sharedPrefs.setString(lastPulledAtKey, timestamp.toIso8601String());
//   }

//   void dispose() {
//     _streamSubscription?.cancel();
//     _streamSubscription = null;
//     _connectionSubscription?.cancel();
//     _connectionSubscription = null;
//   }
// }
