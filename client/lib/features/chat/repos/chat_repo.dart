import 'dart:convert';

import 'package:client/features/chat/models/chat_message_model.dart';
import 'package:http/http.dart' as http;

Stream<http.Response> getGeminiResponseRepo(
  List<ChatMessageModel> messages,
) async* {
  print(messages);
  List<Map<String, dynamic>> mappedMessages = messages
      .map((m) => m.toMap())
      .toList();

  print(mappedMessages);

  var client = http.Client();
  var request = http.Request(
    "POST",
    Uri.parse('http://192.168.1.105:3000/api/v1/generate_response'),
  );
  request.headers['Accept'] = "text/event-stream";
  request.headers['Cache-Control'] = "no-cache";
  request.headers['Content-Type'] = "application/json";
  request.body = jsonEncode({"messages": mappedMessages});
  final response = await client.send(request);

  print(response);

  Stream<http.Response> mappedStream = response.stream
      .transform(utf8.decoder)
      .map((e) {
        return http.Response(e, response.statusCode, headers: response.headers);
      });

  yield* mappedStream;
}
