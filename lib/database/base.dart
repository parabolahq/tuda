import 'package:neat_periodic_task/neat_periodic_task.dart';

class Database {
  late NeatPeriodicTaskScheduler scheduler;
  Map<String, String> links = {'/': 'https://парабола.рус/'};

  Database({Duration interval = const Duration(seconds: 20)}) {
    assert(interval.inSeconds >= 10);

    scheduler = NeatPeriodicTaskScheduler(
      name: 'Sync "$runtimeType" database',
      interval: interval,
      timeout: const Duration(seconds: 5),
      minCycle: const Duration(seconds: 5),
      task: () async => links = await sync(),
    );
  }

  Future<String?> search(String name) async => links[name];
  Future<Map<String, String>> sync() => throw UnimplementedError();
}
