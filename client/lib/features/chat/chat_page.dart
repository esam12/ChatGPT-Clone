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
  ChatBloc chatBloc = ChatBloc();

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
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gemini AI',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<ChatBloc, ChatState>(
          bloc: chatBloc,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 80),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: chatBloc.cachedMessages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: chatBloc.cachedMessages[index].role == 'user'
                              ? Colors.blue
                              : Colors.yellow,
                        ),
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 8,
                          top: 8,
                        ),
                        child: Text(
                          chatBloc.cachedMessages[index].content,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      );
                    },
                  ),
                ),

                // Gradient Text
                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.purple, Colors.pink],
                    ).createShader(bounds),
                    child: const Text(
                      'Hello, ISAM',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Suggestion Buttons
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: suggestions
                      .map(
                        (text) => GestureDetector(
                          onTap: () => _fillTextField(text),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              text,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const Spacer(),

                // Chat Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Ask Gemini',
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: const Icon(Icons.add),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.mic, color: Colors.grey),
                                SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    if (_controller.text.isNotEmpty) {
                                      chatBloc.add(
                                        ChatNewMessageEvent(
                                          message: _controller.text,
                                        ),
                                      );
                                    }
                                  },
                                  child: Icon(Icons.send, color: Colors.grey),
                                ),
                                SizedBox(width: 8),
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
                ),

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
