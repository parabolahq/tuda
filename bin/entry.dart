import 'package:tuda/database/notion.dart';
import 'package:sentry/sentry.dart';
import 'package:tuda/core.dart';

void main() async {
  await Sentry.init(
    (options) => options.dsn = String.fromEnvironment('SENTRY_DNS'),
    appRunner: Shorter(database: NotionDatabase()).serve,
  );
}
