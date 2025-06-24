import 'package:client/core/widgets/custom_shapes/wave_bottom_clipper/wave_bottom_clipper_widget.dart';

import 'package:flutter/material.dart';

class OnboardingPageContent {
  final String imagePath;
  final String headerTitle;
  final String description;

  OnboardingPageContent({
    required this.imagePath,
    required this.headerTitle,
    required this.description,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageContent content;

  const OnboardingPage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top + 150,
        ), // Increased height for the logo/app bar area

        Expanded(
          child: Center(
            child: Image.asset(content.imagePath, fit: BoxFit.contain),
          ),
        ),

        // --- The modified text block using ClipPath with WaveBottomClipper ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child:  GWaveBottomClipperWidget(
          
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                20.0,
                20.0,
                20.0,
                35.0,
              ), // Increased bottom padding for wave
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  // Added a subtle shadow as seen in the image
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    content.headerTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    content.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ),
        // This SizedBox ensures there's enough room for the bottom navigation buttons
        const SizedBox(height: 150),
      ],
    );
  }
}