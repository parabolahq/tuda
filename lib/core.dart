import 'dart:io'
    show HttpRequest, HttpServer, HttpStatus, InternetAddress, Platform;

import 'package:tuda/database/base.dart';

class Shorter {
  final Database database;

  const Shorter({required this.database});

  void serve([dynamic address, int? port]) async {
    database.scheduler.start();
    var server = await HttpServer.bind(address ?? InternetAddress.anyIPv6,
        port ?? Platform.environment['TUDA_PORT'] as int)
      ..listen(process);
    print('Listening ${server.address.host} on ${server.port}...');
  }

  void process(HttpRequest request) {
    database.search(request.uri.path).then((String? value) {
      var redirectableUrl = value ?? '/';

      print('Redirecting ${request.uri.path} to $redirectableUrl '
           'from ${request.connectionInfo?.remoteAddress.address}');

      request.response
        ..redirect(Uri.parse(redirectableUrl),
            status: HttpStatus.permanentRedirect)
        ..close();
    });
  }
}
