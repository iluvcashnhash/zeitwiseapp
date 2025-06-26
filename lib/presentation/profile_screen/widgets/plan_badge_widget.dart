import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlanBadgeWidget extends StatelessWidget {
  final String plan;
  final VoidCallback onUpgrade;

  const PlanBadgeWidget({
    super.key,
    required this.plan,
    required this.onUpgrade,
  });

  Color _getPlanColor() {
    switch (plan.toLowerCase()) {
      case 'pro':
        return AppTheme.activeCyan;
      case 'guru':
        return AppTheme.warmGold;
      default:
        return AppTheme.softGray;
    }
  }

  String _getPlanDescription() {
    switch (plan.toLowerCase()) {
      case 'pro':
        return 'Unlimited conversations with all personas';
      case 'guru':
        return 'Premium features + exclusive content';
      default:
        return '5 conversations per day';
    }
  }

  List<String> _getPlanFeatures() {
    switch (plan.toLowerCase()) {
      case 'pro':
        return [
          'Unlimited daily conversations',
          'All persona personalities',
          'Advanced TTS voices',
          'Priority support'
        ];
      case 'guru':
        return [
          'Everything in Pro',
          'Exclusive guru personas',
          'Custom conversation themes',
          'Early access to features'
        ];
      default:
        return [
          '5 conversations per day',
          'Basic personas only',
          'Standard TTS voice',
          'Community support'
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final planColor = _getPlanColor();
    final isFreePlan = plan.toLowerCase() == 'free';

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: planColor.withValues(alpha: 0.3),
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            planColor.withValues(alpha: 0.1),
            planColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: planColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      plan.toUpperCase(),
                      style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                        color: plan.toLowerCase() == 'guru'
                            ? AppTheme.primaryNavy
                            : Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  if (!isFreePlan) ...[
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'verified',
                      color: planColor,
                      size: 20,
                    ),
                  ],
                ],
              ),
              if (isFreePlan)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onUpgrade();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.activeCyan, AppTheme.warmGold],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'upgrade',
                          color: AppTheme.primaryNavy,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Upgrade',
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.primaryNavy,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          // Plan description
          Text(
            _getPlanDescription(),
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisDark,
            ),
          ),
          SizedBox(height: 2.h),
          // Plan features
          Column(
            children: _getPlanFeatures().map((feature) {
              return Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: planColor,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        feature,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMediumEmphasisDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (isFreePlan) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warmGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.warmGold.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb',
                    color: AppTheme.warmGold,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Upgrade to unlock unlimited philosophical conversations',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warmGold,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
