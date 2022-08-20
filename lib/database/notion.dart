import 'dart:convert';
import 'package:tuda/database/base.dart';
import 'package:http/http.dart';

class NotionDatabase extends Database {
  NotionDatabase({
    String? token,
    String? database,
    super.interval = const Duration(minutes: 10),
  })  : token = token ?? String.fromEnvironment('NOTION_TOKEN'),
        database = database ?? String.fromEnvironment('NOTION_DATABASE');

  final String token, database;

  @override
  Future<Map<String, String>> sync() async {
    var response = await post(
      Uri.https('api.notion.com', 'v1/databases/$database/query'),
      headers: {
        'Authorization': 'Bearer $token',
        'Notion-Version': '2021-08-16',
      },
      body: jsonEncode({'filter': {}}),
    );

    var parsed = jsonDecode(response.body);
    if (!parsed.containsKey('results')) return links;

    var updated = <String, String>{};

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

      updated[name.startsWith('/') ? name : '/$name'] = target;
    }

    return updated;
  }
}
