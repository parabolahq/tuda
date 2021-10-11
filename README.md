# Tuda

A simple URL-shorter service written in pure [Dart](https://dart.dev). With [Notion](https://notion.so) as a database, it provides the simplest interface for setting your links.

![Notion "Tuda" database](https://user-images.githubusercontent.com/25728414/136678767-78ad3f24-14a3-4fc5-b5ba-a60637d864aa.png)

## Environment

Those environment variables are required:

| Name              | Description                                                                                        |
| ----------------- | -------------------------------------------------------------------------------------------------- |
| `NOTION_TOKEN`    | Internal integration token that you can get [from Notion](https://www.notion.so/my-integrations).  |
| `NOTION_DATABASE` | Notion's database unique identifier                                                                |
| `TUDA_PORT`       | Port for the web-server                                                                            |
| `SENTRY_DNS`      | DNS for Sentry error handling                                                                      |
