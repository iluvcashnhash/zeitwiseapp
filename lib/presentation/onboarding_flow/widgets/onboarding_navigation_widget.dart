import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingNavigationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isLastPage;

  const OnboardingNavigationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Page indicators
        _buildPageIndicators(),

        SizedBox(height: 3.h),

        // Navigation buttons
        Row(
          children: [
            // Skip/Back button
            if (!isLastPage)
              Expanded(
                child: TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white.withValues(alpha: 0.7),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            if (!isLastPage) SizedBox(width: 4.w),

            // Next/Get Started button
            Expanded(
              flex: isLastPage ? 1 : 2,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isLastPage ? AppTheme.warmGold : AppTheme.activeCyan,
                  foregroundColor: AppTheme.primaryNavy,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  elevation: 4,
                  shadowColor:
                      (isLastPage ? AppTheme.warmGold : AppTheme.activeCyan)
                          .withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastPage ? 'Get Started' : 'Next',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryNavy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (!isLastPage) ...[
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: AppTheme.primaryNavy,
                        size: 5.w,
                      ),
                    ],
                    if (isLastPage) ...[
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'rocket_launch',
                        color: AppTheme.primaryNavy,
                        size: 5.w,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          width: index == currentPage ? 8.w : 2.w,
          height: 1.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: index == currentPage
                ? AppTheme.activeCyan
                : Colors.white.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
