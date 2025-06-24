import 'package:flutter/material.dart';

// --- Custom Clipper for the rounded top and wave bottom shape ---
class WaveBottomClipper extends CustomClipper<Path> {
  final double topBorderRadius;
  final double waveHeight; // Controls the depth of the dip from the bottom edge
  final double
  bottomCornerWaveDepth; // How much the wave dips at the corners before the main wave

  WaveBottomClipper({
    this.topBorderRadius = 20.0,
    this.waveHeight = 25.0, // How deep the main wave goes
    this.bottomCornerWaveDepth =
        15.0, // Depth of the curve at the immediate corners
  });

  @override
  Path getClip(Size size) {
    Path path = Path();

    double width = size.width;
    double height = size.height;

    // 1. Start at the top-left, after the radius start
    path.moveTo(topBorderRadius, 0);

    // 2. Top straight line
    path.lineTo(width - topBorderRadius, 0);

    // 3. Top-right rounded corner
    path.quadraticBezierTo(width, 0, width, topBorderRadius);

    // 4. Right straight side (down to where the bottom wave/curve begins)
    path.lineTo(width, height - bottomCornerWaveDepth);

    // 5. Bottom-right corner curve (part of the wave starting from the right)
    // Control point is directly at the bottom-right corner for a sharp angle start to the curve
    path.quadraticBezierTo(
      width,
      height,
      width - bottomCornerWaveDepth,
      height,
    );

    // 6. First part of the wave (from bottom-right curve end to the main dip in the middle)
    // The control point influences the curve's 'pull'
    double cp1x = width * 0.75; // Control point horizontal position
    double cp1y =
        height -
        waveHeight; // Control point vertical position (above the bottom line)

    double midX = width / 2;
    double midY =
        height +
        waveHeight; // The deepest point of the wave (dips below the actual height)

    path.quadraticBezierTo(cp1x, cp1y, midX, midY);

    // 7. Second part of the wave (from main dip to bottom-left corner curve start)
    double cp2x = width * 0.25; // Control point horizontal position
    double cp2y =
        height -
        waveHeight; // Control point vertical position (symmetric to cp1y)

    double endWaveX = bottomCornerWaveDepth;
    double endWaveY = height; // End point of the wave (on the bottom edge)

    path.quadraticBezierTo(cp2x, cp2y, endWaveX, endWaveY);

    // 8. Bottom-left corner curve (completing the wave and connecting to the left side)
    path.quadraticBezierTo(0, height, 0, height - bottomCornerWaveDepth);

    // 9. Left straight side (up to top-left rounded corner start)
    path.lineTo(
      0,
      topBorderRadius,
    ); // Go straight up to the start of the top-left curve

    path.close(); // Closes the path, connecting the final point back to the very first point

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (oldClipper is WaveBottomClipper) {
      return oldClipper.topBorderRadius != topBorderRadius ||
          oldClipper.waveHeight != waveHeight ||
          oldClipper.bottomCornerWaveDepth != bottomCornerWaveDepth;
    }
    return true;
  }
}

// --- Your existing main.dart content starts here ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnboardingScreen(),
    );
  }
}

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
      // The actual app bar from your screenshot is more complex, involving a custom shape.
      // For simplicity, we'll just have the background color here or remove it if not needed.
      // appBar: AppBar(
      //   title: Text('efendim.app'),
      //   centerTitle: true,
      //   // You'd need a custom shape for the AppBar too if you want that effect
      // ),
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
                print('Skip button pressed');
              },
              style: TextButton.styleFrom(
                backgroundColor:
                    Colors.yellow.shade200, // Example background color
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

          // Top Header (efendim.app logo and text) - this is just a placeholder, your image shows a custom app bar
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/gemini_ai.png', // Replace with your logo path
                    height: 50,
                  ),
                  const Text(
                    'efendim.app',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                            print('Done button pressed');
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
      width: currentPage == index ? 24 : 8, // Wider for active dot
      decoration: BoxDecoration(
        color: currentPage == index
            ? Colors.blue
            : Colors.grey.shade400, // Active vs inactive color
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

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

  const OnboardingPage({Key? key, required this.content}) : super(key: key);

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
          child: ClipPath(
            clipper: WaveBottomClipper(
              topBorderRadius: 20.0,
              waveHeight: 25.0, // Adjust for deeper/shallower wave
              bottomCornerWaveDepth:
                  15.0, // Adjust for how pronounced the corner curve is
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                20.0,
                20.0,
                20.0,
                35.0,
              ), // Increased bottom padding for wave
              decoration: BoxDecoration(
                color: Colors.yellow.shade100, // Background color for the block
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
