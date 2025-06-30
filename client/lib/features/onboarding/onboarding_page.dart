import 'package:client/features/chat/chat_page.dart';
import 'package:client/features/onboarding/widgets/onboarding_page_content.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // Define your onboarding pages content
  final List<OnboardingPageContent> pages = [
    OnboardingPageContent(
      imagePath: 'assets/images/gemini_ai.png', // Replace with your image paths
      headerTitle: 'Add your ad in just a few steps',
      description:
          'Add your ad in just two steps, let it reach many interested people, and complete your deal',
    ),
    OnboardingPageContent(
      imagePath: 'assets/images/gemini_ai.png',
      headerTitle: 'Discover amazing deals',
      description:
          'Explore a wide variety of ads and find exactly what you\'re looking for.',
    ),
    OnboardingPageContent(
      imagePath: 'assets/images/gemini_ai.png',
      headerTitle: 'Connect with sellers',
      description:
          'Chat directly with sellers and finalize your purchases with ease.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main PageView
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(content: pages[index]);
            },
          ),

          // Skip Button (Top Left - corrected position based on your image)
          Positioned(
            top: 50, // Adjust as needed
            left: 20, // Positioned on the left now
            child: TextButton(
              onPressed: () {
                // Handle skip action, navigate to main app
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GeminiLikeScreen(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white, // Example background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text('Skip', style: TextStyle(color: Colors.black)),
            ),
          ),

          // Page Indicators and Navigation Buttons (Bottom)
          Positioned(
            bottom: 50, // Adjust as needed
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => buildDot(index, _currentPage),
                  ),
                ),
                const SizedBox(height: 30), // Spacing between dots and buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      Opacity(
                        opacity: _currentPage == 0
                            ? 0.0
                            : 1.0, // Hide on first page
                        child: FloatingActionButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                          heroTag:
                              'backBtn', // Unique tag for each FloatingActionButton
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // Next/Done Button
                      FloatingActionButton(
                        onPressed: () {
                          if (_currentPage < pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          } else {
                            // Last page, navigate to main app
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GeminiLikeScreen(),
                              ),
                            );
                          }
                        },

                        heroTag: 'nextDoneBtn', // Unique tag
                        backgroundColor: Colors.white, // Adjust color as needed
                        child: Icon(
                          _currentPage == pages.length - 1
                              ? Icons
                                    .check // Checkmark for the last page
                              : Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, int currentPage) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: currentPage == index
            ? Colors.white
            : Colors.grey.shade400, // Active vs inactive color
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
