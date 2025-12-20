import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/routes/routeConstant.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../store/authProvider.dart';
import '../../store/utils/shared_storage.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> _onboardingData = const [
    {
      'image': 'assets/boarding/boarding_1.png',
      'title': '',
      'subtitle': 'Your gateway to smart, efficient services.',
    },
    {
      'image': 'assets/boarding/boarding_2.png',
      'title': 'Discover how easy buying can be',
      'subtitle':
          'Browse available properties, explore payment options, and complete transactions effortlessly.',
    },
    {
      'image': 'assets/boarding/boarding_3.png',
      'title': 'Book your perfect stay in one click',
      'subtitle': 'Enjoy a seamless hotel booking experience with just a tap.',
    },
    {
      'image': 'assets/boarding/boarding_4.png',
      'title': 'Invest in your dream property effortlessly',
      'subtitle':
          'Just one click is all it takes to start your investment journey.',
    },
  ];

  Future<void> _completeOnboarding() async {
    await LocalStorageService.isFirstLaunch('isFirstLaunch', false);

    // 🔑 Notify router that onboarding is done
    ref.invalidate(firstLaunchProvider);

    if (!mounted) return;

    // Router will redirect correctly
    context.go(AppRoutes.home);
  }

  void _nextPage() {
    if (currentIndex < _onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _completeOnboarding,
            child: const Text('Skip', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              final item = _onboardingData[index];
              final isFirstPage = index == 0;

              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: isFirstPage
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(item['image']!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const BoxDecoration(color: Colors.white),
                child: Stack(
                  children: [
                    if (isFirstPage)
                      Container(
                        decoration: const BoxDecoration(color: Colors.black54),
                      ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: !isFirstPage
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      140,
                                      10,
                                    ),
                                    child: Text(
                                      item['title']!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 20,
                                      right: 50,
                                    ),
                                    child: Text(
                                      item['subtitle']!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        item['image']!,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Image(
                                      image: AssetImage(
                                        'assets/brand/logo.png',
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _onboardingData.length,
                  effect: WormEffect(
                    activeDotColor: theme.primaryColor,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsetsDirectional.symmetric(vertical: 20),
                      ),
                    ),
                    onPressed: _nextPage,
                    child: Text(
                      style: TextStyle(fontSize: 16),
                      currentIndex == _onboardingData.length - 1
                          ? 'Get Started'
                          : 'Next',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
