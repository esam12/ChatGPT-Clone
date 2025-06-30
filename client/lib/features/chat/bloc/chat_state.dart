part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;
  ChatError({required this.message});
}

class ChatNewMessageGenerated extends ChatState {}
