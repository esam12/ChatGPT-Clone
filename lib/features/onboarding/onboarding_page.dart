import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.5,
              width: size.width,
              child: Image.asset('assets/images/gemini_ai.png'),
            ),
            Text(
              'Welcome to our app!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              'This is the onboarding page',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
