import 'package:neat_periodic_task/neat_periodic_task.dart';
import 'package:sentry/sentry.dart';

class Database {
  late final NeatPeriodicTaskScheduler scheduler;
  Map<String, String> links = {};

  Database({Duration interval = const Duration(seconds: 20)})
      : assert(interval.inSeconds >= 10) {
    scheduler = NeatPeriodicTaskScheduler(
      name: 'Sync of "$runtimeType" database',
      interval: interval,
      timeout: const Duration(seconds: 5),
      minCycle: const Duration(seconds: 5),
      task: () => sync().then(
        (Map<String, String> value) => links = value,
        onError: (error, stackTrace) => Sentry.captureException(
          error,
          stackTrace: stackTrace,
        ),
      ),
    );
  }

  Future<String?> search(String name) async => links[name];
  Future<Map<String, String>> sync() => throw UnimplementedError();
}
