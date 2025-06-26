import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingSlideWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isActive;

  const OnboardingSlideWidget({
    super.key,
    required this.data,
    required this.isActive,
  });

  @override
  State<OnboardingSlideWidget> createState() => _OnboardingSlideWidgetState();
}

class _OnboardingSlideWidgetState extends State<OnboardingSlideWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.isActive) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(OnboardingSlideWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _animationController.forward();
    } else if (!widget.isActive && oldWidget.isActive) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: (widget.data['gradient'] as List<Color>?) ??
              [
                AppTheme.primaryNavy,
                AppTheme.brandIndigo,
              ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          children: [
            SizedBox(height: 4.h),

            // Main image/illustration
            Expanded(
              flex: 3,
              child: _buildMainContent(),
            ),

            SizedBox(height: 4.h),

            // Text content
            Expanded(
              flex: 2,
              child: _buildTextContent(),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildContentByType(),
          ),
        );
      },
    );
  }

  Widget _buildContentByType() {
    switch (widget.data['type']) {
      case 'welcome':
        return _buildWelcomeContent();
      case 'chat':
        return _buildChatContent();
      case 'detox':
        return _buildDetoxContent();
      case 'subscription':
        return _buildSubscriptionContent();
      default:
        return _buildWelcomeContent();
    }
  }

  Widget _buildWelcomeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App logo placeholder
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppTheme.activeCyan, AppTheme.warmGold],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.activeCyan.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'psychology',
              color: Colors.white,
              size: 12.w,
            ),
          ),
        ),

        SizedBox(height: 4.h),

        // Floating wisdom elements
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFloatingElement('💭', -0.5),
            _buildFloatingElement('🧠', 0.3),
            _buildFloatingElement('✨', -0.2),
          ],
        ),
      ],
    );
  }

  Widget _buildChatContent() {
    final personas =
        widget.data['personas'] as List<Map<String, dynamic>>? ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Persona avatars
        SizedBox(
          height: 15.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: personas.length,
            itemBuilder: (context, index) {
              final persona = personas[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                child: Column(
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: index == 0
                              ? AppTheme.activeCyan
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: index == 0
                            ? [
                                BoxShadow(
                                  color: AppTheme.activeCyan
                                      .withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: persona['avatar'] as String,
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      persona['name'] as String,
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        SizedBox(height: 4.h),

        // Sample chat bubbles
        _buildSampleChatBubbles(),
      ],
    );
  }

  Widget _buildDetoxContent() {
    final transformation =
        widget.data['transformation'] as Map<String, dynamic>? ?? {};

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Before/After transformation
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              // Before
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red.withValues(alpha: 0.2),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'warning',
                      color: Colors.red.shade300,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        transformation['before'] as String? ?? '',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Arrow
              CustomIconWidget(
                iconName: 'arrow_downward',
                color: AppTheme.warmGold,
                size: 6.w,
              ),

              SizedBox(height: 2.h),

              // After
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppTheme.successGreen.withValues(alpha: 0.2),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'lightbulb',
                      color: AppTheme.warmGold,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        transformation['after'] as String? ?? '',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionContent() {
    final plans = widget.data['plans'] as List<Map<String, dynamic>>? ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Plan cards
        SizedBox(
          height: 22.h, // Increased height to accommodate text better
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              final isRecommended = index == 1;

              return Container(
                width: 28.w, // Increased width for better text fit
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: isRecommended
                        ? AppTheme.warmGold
                        : Colors.white.withValues(alpha: 0.2),
                    width: isRecommended ? 2 : 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.w), // Increased padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isRecommended)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppTheme.warmGold,
                          ),
                          child: Text(
                            'Popular',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.primaryNavy,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  10.sp, // Reduced font size for better fit
                            ),
                          ),
                        ),
                      SizedBox(height: 1.h),
                      Text(
                        plan['name'] as String,
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp, // Reduced font size
                        ),
                      ),
                      SizedBox(height: 1.h),
                      ...((plan['features'] as List<String>?) ?? [])
                          .take(3)
                          .map(
                            (feature) => Padding(
                              padding: EdgeInsets.only(bottom: 0.5.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'check_circle',
                                    color: AppTheme.successGreen,
                                    size: 3.w,
                                  ),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: AppTheme
                                          .darkTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                        fontSize: 10.sp, // Reduced font size
                                        height: 1.2, // Reduced line height
                                      ),
                                      maxLines: 2, // Limit to 2 lines
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingElement(String emoji, double offset) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 2000 + (offset * 500).abs().round()),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, offset * 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Text(
              emoji,
              style: TextStyle(fontSize: 8.w),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSampleChatBubbles() {
    return Column(
      children: [
        // Bot message
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(maxWidth: 70.w),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.parchmentCream.withValues(alpha: 0.9),
            ),
            child: Text(
              "Welcome, seeker of wisdom. What troubles your mind today?",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryNavy,
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // User message
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(maxWidth: 70.w),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.brandIndigo,
            ),
            child: Text(
              "I feel overwhelmed by all the negative news...",
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent() {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          Text(
            widget.data['title'] as String? ?? '',
            style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            widget.data['subtitle'] as String? ?? '',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.warmGold,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            widget.data['description'] as String? ?? '',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
