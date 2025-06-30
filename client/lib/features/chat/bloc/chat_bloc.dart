import 'dart:async';

import 'package:client/features/chat/repos/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:client/features/chat/models/chat_message_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatNewMessageEvent>(chatNewMessageEvent);
    on<ChatNewContentEvent>(chatNewContentEvent);
  }

  StreamSubscription<http.Response>? _subscription;
  List<ChatMessageModel> cachedMessages = [];

  FutureOr<void> chatNewMessageEvent(
    ChatNewMessageEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(ChatLoading());

    try {
      cachedMessages.add(
        ChatMessageModel(role: 'user', content: event.message),
      );

      emit(ChatNewMessageGenerated());
      cachedMessages.add(ChatMessageModel(role: 'model', content: ''));

      _subscription?.cancel();
      _subscription = getGeminiResponseRepo(cachedMessages).listen((response) {
        for (String line in response.body.split('\n')) {
          String content = line.replaceFirst('data: ', "").trim();
          add(ChatNewContentEvent(content: content));
          
        }
      });
    } catch (e) {
      print(e.toString());
      emit(ChatError(message: e.toString()));
    }

    // if (response.statusCode == 200) {
    //   emit(ChatLoaded(messages: cachedMessages));
    // } else {
    //   emit(ChatError());
    // }
  }

  FutureOr<void> chatNewContentEvent(
    ChatNewContentEvent event,
    Emitter<ChatState> emit,
  ) {
    ChatMessageModel modelMessage = cachedMessages.last;
    String message = event.content;
    cachedMessages.last = ChatMessageModel(
      role: 'model',
      content: modelMessage.content + message,
    );
    emit(ChatNewMessageGenerated());
  }
}
