part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class ChatNewMessageEvent extends ChatEvent {
  final String message;
  ChatNewMessageEvent({required this.message});
}

class ChatNewContentEvent extends ChatEvent {
  final String content;
  ChatNewContentEvent({required this.content});
}