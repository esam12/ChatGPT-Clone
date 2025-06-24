import 'package:flutter/material.dart';

class GeminiLikeScreen extends StatefulWidget {
  const GeminiLikeScreen({super.key});

  @override
  State<GeminiLikeScreen> createState() => _GeminiLikeScreenState();
}

class _GeminiLikeScreenState extends State<GeminiLikeScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> suggestions = [
    'Give me study tips',
    'Inspire me',
    'Save me time',
    'Tell me what you can do',
  ];

  @override
  void dispose() {
    _controller.dispose();
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),

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
                  .map((text) => GestureDetector(
                        onTap: () => _fillTextField(text),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:
                              Text(text, style: const TextStyle(fontSize: 14)),
                        ),
                      ))
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
                        suffixIcon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mic, color: Colors.grey),
                            SizedBox(width: 8),
                            Icon(Icons.graphic_eq, color: Colors.grey),
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
        ),
      ),
    );
  }
}
