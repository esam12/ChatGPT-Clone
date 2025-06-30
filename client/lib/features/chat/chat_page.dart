import 'package:client/features/chat/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeminiLikeScreen extends StatefulWidget {
  const GeminiLikeScreen({super.key});

  @override
  State<GeminiLikeScreen> createState() => _GeminiLikeScreenState();
}

class _GeminiLikeScreenState extends State<GeminiLikeScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatBloc chatBloc = ChatBloc();

  final List<String> suggestions = [
    'Give me study tips',
    'Inspire me',
    'Save me time',
    'Tell me what you can do',
  ];

  @override
  void dispose() {
    _controller.dispose();
    chatBloc.close();
    super.dispose();
  }

  void _fillTextField(String text) {
    setState(() {
      _controller.text = text;
      _controller.selection = TextSelection.collapsed(offset: text.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gemini AI',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<ChatBloc, ChatState>(
          bloc: chatBloc,
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                if (chatBloc.cachedMessages.isEmpty) const SizedBox(height: 80),
                Expanded(child: _buildMessagesList(context)),
                if (chatBloc.cachedMessages.isEmpty) _buildSuggestions(),
                const SizedBox(height: 16),
                _buildInputField(),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: chatBloc.cachedMessages.length,
      itemBuilder: (context, index) {
        final message = chatBloc.cachedMessages[index];
        final isUser = message.role == 'user';

        return Container(
          decoration: BoxDecoration(color: Colors.black54),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: isUser
                ? [
                    Expanded(
                      child: _buildMessageBubble(
                        context,
                        message.content,
                        isUser,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildAvatar(isUser),
                  ]
                : [
                    _buildAvatar(isUser),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMessageBubble(
                        context,
                        message.content,
                        isUser,
                      ),
                    ),
                  ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isUser
                ? 'assets/images/profile.png'
                : 'assets/images/google-gemini-icon.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: suggestions.map((text) {
        return GestureDetector(
          onTap: () => _fillTextField(text),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ask Gemini',
                filled: true,
                fillColor: Colors.white24,
                prefixIcon: const Icon(Icons.add),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mic, color: Colors.grey),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        if (_controller.text.trim().isNotEmpty) {
                          chatBloc.add(
                            ChatNewMessageEvent(
                              message: _controller.text.trim(),
                            ),
                          );
                          _controller.clear();
                        }
                      },
                      child: const Icon(Icons.send, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMessageBubble(BuildContext context, String content, bool isUser) {
  return Container(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isUser ? 16 : 0),
        topRight: Radius.circular(isUser ? 0 : 16),
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
    ),
    child: Text(content, style: Theme.of(context).textTheme.titleMedium),
  );
}
