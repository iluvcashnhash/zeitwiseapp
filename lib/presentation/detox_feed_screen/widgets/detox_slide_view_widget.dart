import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DetoxSlideViewWidget extends StatefulWidget {
  final Map<String, dynamic> article;

  const DetoxSlideViewWidget({
    super.key,
    required this.article,
  });

  @override
  State<DetoxSlideViewWidget> createState() => _DetoxSlideViewWidgetState();
}

class _DetoxSlideViewWidgetState extends State<DetoxSlideViewWidget>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _colorAnimationController;
  late Animation<Color?> _backgroundColorAnimation;
  int _currentPage = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _colorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _updateBackgroundAnimation();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _colorAnimationController.dispose();
    super.dispose();
  }

  void _updateBackgroundAnimation() {
    final slides = (widget.article['slides'] as List);
    if (_currentPage < slides.length - 1) {
      final currentColor = slides[_currentPage]['backgroundColor'] as Color;
      final nextColor = slides[_currentPage + 1]['backgroundColor'] as Color;

      _backgroundColorAnimation = ColorTween(
        begin: currentColor,
        end: nextColor,
      ).animate(CurveTween(curve: Curves.easeInOut)
          .animate(_colorAnimationController));
    }
  }

  void _onPageChanged(int page) {
    if (_isAnimating) return;

    setState(() {
      _currentPage = page;
      _isAnimating = true;
    });

    HapticFeedback.lightImpact();
    _updateBackgroundAnimation();

    _colorAnimationController.forward().then((_) {
      _colorAnimationController.reset();
      setState(() {
        _isAnimating = false;
      });
    });
  }

  void _shareContent() {
    HapticFeedback.mediumImpact();
    final slides = (widget.article['slides'] as List);
    if (_currentPage == slides.length - 1) {
      final memeSlide = slides[_currentPage];
      Share.share(
        'Check out this wisdom meme: ${memeSlide['caption']}\n\nShared from ZeitWise',
        subject: 'Wisdom Meme from ZeitWise',
      );
    }
  }

  Widget _buildSlide(Map<String, dynamic> slide, int index) {
    final slideType = slide['type'] as String;

    switch (slideType) {
      case 'headline':
        return _buildHeadlineSlide(slide);
      case 'rawdetails':
        return _buildRawDetailsSlide(slide);
      case 'historical':
        return _buildHistoricalSlide(slide);
      case 'analysis':
        return _buildAnalysisSlide(slide);
      case 'meme':
        return _buildMemeSlide(slide);
      default:
        return Container();
    }
  }

  Widget _buildHeadlineSlide(Map<String, dynamic> slide) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryNavy,
            AppTheme.primaryNavy.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'warning_amber',
                color: AppTheme.warmGold,
                size: 48,
              ),
              SizedBox(height: 4.h),
              Text(
                'RAW NEWS',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.warmGold,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
              ),
              SizedBox(height: 2.h),
              Text(
                slide['content'] ?? '',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  'Swipe for details →',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRawDetailsSlide(Map<String, dynamic> slide) {
    final details = slide['details'] as List<String>? ?? [];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF7F1D1D), // Dark red for anxiety
            Color(0xFF991B1B).withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'crisis_alert',
                  color: Colors.red.shade300,
                  size: 32,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'RAW DETAILS',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.red.shade200,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
              ),
              SizedBox(height: 1.h),
              Text(
                'The anxiety-inducing facts',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: details.map((detail) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 0.5.h, right: 3.w),
                            width: 1.w,
                            height: 1.w,
                            decoration: BoxDecoration(
                              color: Colors.red.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              detail,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    height: 1.4,
                                    fontSize: 15.sp,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  'Swipe for perspective →',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoricalSlide(Map<String, dynamic> slide) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.historicalSepia,
            AppTheme.historicalSepia.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.parchmentCream,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  slide['year'] ?? '',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.historicalSepia,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              SizedBox(height: 4.h),
              CustomIconWidget(
                iconName: 'history_edu',
                color: AppTheme.parchmentCream,
                size: 48,
              ),
              SizedBox(height: 4.h),
              Text(
                'HISTORICAL PARALLEL',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.parchmentCream,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.parchmentCream.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.parchmentCream.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  slide['content'] ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.parchmentCream,
                        height: 1.6,
                        fontSize: 16.sp,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisSlide(Map<String, dynamic> slide) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightIndigo,
            AppTheme.lightIndigo.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.brandIndigo.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.brandIndigo,
                    size: 32,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'SAGE ANALYSIS',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.brandIndigo,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
              ),
              SizedBox(height: 1.h),
              Text(
                'by ${slide['sage'] ?? 'Ancient Wisdom'}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.brandIndigo.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.brandIndigo.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'format_quote',
                      color: AppTheme.brandIndigo.withValues(alpha: 0.3),
                      size: 24,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      slide['content'] ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.primaryNavy,
                            height: 1.6,
                            fontSize: 16.sp,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemeSlide(Map<String, dynamic> slide) {
    return GestureDetector(
      onLongPress: _shareContent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.warmGold,
              AppTheme.warmGold.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'WISDOM MEME',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.primaryNavy,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                ),
                SizedBox(height: 4.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        CustomImageWidget(
                          imageUrl: slide['imageUrl'] ?? '',
                          width: 80.w,
                          height: 40.h,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.6),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4.w,
                          left: 4.w,
                          right: 4.w,
                          child: Text(
                            slide['caption'] ?? '',
                            style: TextStyle(
                              fontFamily: 'Impact',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.8),
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryNavy.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryNavy.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.primaryNavy,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Long press to share',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryNavy,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slides = (widget.article['slides'] as List);

    return Scaffold(
      backgroundColor: AppTheme.primaryNavy,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _backgroundColorAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  color: _isAnimating && _backgroundColorAnimation.value != null
                      ? _backgroundColorAnimation.value
                      : slides[_currentPage]['backgroundColor'] as Color,
                ),
              );
            },
          ),
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: slides.length,
            itemBuilder: (context, index) {
              return _buildSlide(slides[index], index);
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 2.h,
            left: 4.w,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  width: _currentPage == index ? 8.w : 2.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
