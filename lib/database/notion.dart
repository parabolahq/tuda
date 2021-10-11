import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show Platform;

import 'package:tuda/database/base.dart' show Database;
import 'package:http/http.dart' show post;

class NotionDatabase extends Database {
  NotionDatabase({
    String? token,
    String? database,
    Duration interval = const Duration(minutes: 10),
  }) : super(interval: interval) {
    _token = token ?? Platform.environment['NOTION_TOKEN']!;
    _database = database ?? Platform.environment['NOTION_DATABASE']!;
  }

  late String _token, _database;

  @override
  Future<Map<String, String>> sync() async {
    var response = await post(
      Uri.https('api.notion.com', 'v1/databases/$_database/query'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Notion-Version': '2021-08-16',
      },
      body: jsonEncode(
        {'filter': {}},
      ),
    );

    var parsed = jsonDecode(response.body);
    if (!parsed.containsKey('results')) return links;

    var newLinks = <String, String>{};

    for (var page in parsed['results']) {
      if (page['object'] != 'page') continue;
      var properties = page['properties'].values.toList() as List<dynamic>;

      var nameProperty =
          properties.firstWhere((element) => element['type'] == 'title');
      var targetProperty =
          properties.firstWhere((element) => element['type'] == 'url');

      if (nameProperty['title'].isEmpty) continue;

      var name = nameProperty['title'].elementAt(0)['plain_text'] as String;
      var target = targetProperty['url'] as String;

      if (name.replaceAll(' ', '').isEmpty ||
          target.replaceAll(' ', '').isEmpty) continue;

      newLinks[name.startsWith('/') ? name : '/$name'] = target;
    }

    return newLinks;
  }
}
