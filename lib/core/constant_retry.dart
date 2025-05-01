import 'dart:async';
import 'dart:math' as math;

import 'package:custom_supabase_drift_sync/core/error_handling.dart';

/// Custom retry function that attempts with a specific delay sequence
/// [500ms, 1000ms, 2000ms, 2000ms, 2000ms] plus randomization factor
Future<T> sequenceRetry<T>(
  FutureOr<T> Function() fn, {
  List<Duration> delaySequence = const [
    Duration(milliseconds: 500),
    Duration(milliseconds: 1000),
    Duration(milliseconds: 2000),
    Duration(milliseconds: 2000),
    Duration(milliseconds: 2000),
    Duration(milliseconds: 2000),
    Duration(milliseconds: 3000),
    Duration(milliseconds: 3000),
    Duration(milliseconds: 4000),
    Duration(milliseconds: 4000),
    Duration(milliseconds: 5000),
    Duration(milliseconds: 5000),
    Duration(milliseconds: 5000),
    Duration(milliseconds: 5000),
    Duration(milliseconds: 5000),
  ],
  double randomizationFactor = 0.25,
}) async {
  final random = math.Random();
  var attempt = 0;

  while (true) {
    try {
      return await fn();
    } catch (e) {
      attempt++;

      // If we've exhausted all retries, rethrow the exception
      if (attempt >= delaySequence.length) {
        E.t.debug('Max attempts reached: $attempt');
        rethrow;
      }

      // Get the base delay for this attempt
      final baseDelay = delaySequence[attempt - 1];

      // Apply randomization
      final randomized =
          1.0 + randomizationFactor * (random.nextDouble() * 2 - 1);
      final delay = Duration(
          milliseconds: (baseDelay.inMilliseconds * randomized).round());

      E.t.debug(
          'Attempt $attempt failed, retrying in ${delay.inMilliseconds}ms');
      // Wait before the next attempt
      await Future.delayed(delay);
    }
  }
}
