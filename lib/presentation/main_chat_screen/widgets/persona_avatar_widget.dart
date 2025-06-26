import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonaAvatarWidget extends StatelessWidget {
  final Map<String, dynamic> persona;
  final bool isSelected;
  final VoidCallback onTap;
  final Animation<double> glowAnimation;

  const PersonaAvatarWidget({
    super.key,
    required this.persona,
    required this.isSelected,
    required this.onTap,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.activeCyan
                                  .withValues(alpha: glowAnimation.value * 0.6),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ]
                        : null,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.activeCyan
                              .withValues(alpha: glowAnimation.value)
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: persona['avatar'],
                      width: 16.w,
                      height: 16.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 1.h),
            Container(
              constraints: BoxConstraints(maxWidth: 20.w),
              child: Text(
                persona['name'],
                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                  color: isSelected ? AppTheme.activeCyan : AppTheme.softGray,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
