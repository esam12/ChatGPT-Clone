class ChatMessageModel {
  final String role;
  final String content;

  ChatMessageModel({required this.content, required this.role});

  Map<String, dynamic> toMap() {
    return {'text': content, 'role': role};
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      role: map['role'] ?? '',
      content: map['text'] ?? '',
    );
  }
}
