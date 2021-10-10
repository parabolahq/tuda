import 'dart:io' show Platform;

import 'package:sentry/sentry.dart';
import 'package:tuda/core.dart';
import 'package:tuda/database/notion.dart';

void main() async {
  await Sentry.init(
    (options) => options.dsn = Platform.environment['SENTRY_DNS'],
    appRunner: Shorter(database: NotionDatabase()).serve,
  );
}
