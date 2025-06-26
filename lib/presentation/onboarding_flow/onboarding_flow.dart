import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/onboarding_navigation_widget.dart';
import './widgets/onboarding_slide_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;
  final int _totalPages = 4;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Welcome to ZeitWise",
      "subtitle": "Transform anxiety into wisdom",
      "description":
          "Turn doom-scrolling into meaningful conversations with AI philosophers who help you find peace and perspective in our chaotic world.",
      "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
      "gradient": [AppTheme.primaryNavy, AppTheme.brandIndigo],
      "type": "welcome"
    },
    {
      "title": "Chat with Ancient Wisdom",
      "subtitle": "5 unique AI personas await",
      "description":
          "Engage with Socrates, Diogenes, Nicolas-the-Smoker, Cyber-Confucius, and Sarcastic Marx. Each brings their unique perspective to your modern challenges.",
      "image":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop&crop=face",
      "gradient": [AppTheme.brandIndigo, AppTheme.activeCyan],
      "type": "chat",
      "personas": [
        {
          "name": "Socrates",
          "avatar":
              "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=60&h=60&fit=crop&crop=face"
        },
        {
          "name": "Diogenes",
          "avatar":
              "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=60&h=60&fit=crop&crop=face"
        },
        {
          "name": "Nicolas",
          "avatar":
              "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=60&h=60&fit=crop&crop=face"
        },
        {
          "name": "Confucius",
          "avatar":
              "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=60&h=60&fit=crop&crop=face"
        },
        {
          "name": "Marx",
          "avatar":
              "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=60&h=60&fit=crop&crop=face"
        }
      ]
    },
    {
      "title": "Detox Your Feed",
      "subtitle": "Transform negative news",
      "description":
          "Watch headlines transform from anxiety-inducing to wisdom-inspiring through historical context, sage analysis, and healing humor.",
      "image":
          "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400&h=400&fit=crop",
      "gradient": [AppTheme.activeCyan, AppTheme.warmGold],
      "type": "detox",
      "transformation": {
        "before": "Breaking: Economic Crisis Deepens",
        "after":
            "Historical Perspective: How Past Generations Overcame Similar Challenges"
      }
    },
    {
      "title": "Unlock Your Potential",
      "subtitle": "Choose your wisdom journey",
      "description":
          "Start free with basic conversations, or unlock Pro features for deeper insights, exclusive personas, and advanced mindfulness tools.",
      "image":
          "https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400&h=400&fit=crop",
      "gradient": [AppTheme.warmGold, AppTheme.successGreen],
      "type": "subscription",
      "plans": [
        {
          "name": "Free",
          "features": ["Basic chat", "3 personas", "Daily wisdom"]
        },
        {
          "name": "Pro",
          "features": ["All personas", "Voice chat", "Unlimited conversations"]
        },
        {
          "name": "Guru",
          "features": ["Everything", "Priority support", "Exclusive content"]
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.selectionClick();
    Navigator.pushReplacementNamed(context, '/main-chat-screen');
  }

  void _getStarted() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/main-chat-screen');
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryNavy,
      body: SafeArea(
        child: Stack(
          children: [
            // Progress indicator
            Positioned(
              top: 2.h,
              left: 5.w,
              right: 5.w,
              child: _buildProgressIndicator(),
            ),

            // Skip button
            Positioned(
              top: 2.h,
              right: 5.w,
              child: TextButton(
                onPressed: _skipOnboarding,
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
                child: Text(
                  'Skip',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),

            // Main content
            Positioned.fill(
              top: 8.h,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: OnboardingSlideWidget(
                      data: _onboardingData[index],
                      isActive: index == _currentPage,
                    ),
                  );
                },
              ),
            ),

            // Navigation controls
            Positioned(
              bottom: 4.h,
              left: 5.w,
              right: 5.w,
              child: OnboardingNavigationWidget(
                currentPage: _currentPage,
                totalPages: _totalPages,
                onNext: _nextPage,
                onSkip: _skipOnboarding,
                isLastPage: _currentPage == _totalPages - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 0.5.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.white.withValues(alpha: 0.2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (_currentPage + 1) / _totalPages,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [AppTheme.activeCyan, AppTheme.warmGold],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
    );
  }
}
