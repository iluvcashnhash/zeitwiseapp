import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onEmojiTap;
  final VoidCallback onMicTap;

  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onEmojiTap,
    required this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15.h, // Made thinner for elegance
      decoration: BoxDecoration(
        // Glass blur effect
        color: AppTheme.darkTheme.cardColor.withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
        // Subtle gradient overlay
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              // Emoji Button - Minimal design
              GestureDetector(
                onTap: onEmojiTap,
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'emoji_emotions',
                    color: AppTheme.warmGold.withValues(alpha: 0.8),
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),

              // Text Input Field - Clean white with 2xl corner radius
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 10.w,
                    maxHeight: 25.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // Clean white background
                    borderRadius:
                        BorderRadius.circular(32), // 2xl corner radius
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryNavy,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts...',
                      hintStyle:
                          AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.softGray,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 3.w,
                      ),
                    ),
                    onSubmitted: (_) => onSend(),
                  ),
                ),
              ),
              SizedBox(width: 3.w),

              // Microphone Button - Minimal design
              GestureDetector(
                onTap: onMicTap,
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: AppTheme.activeCyan.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.activeCyan.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'mic',
                    color: AppTheme.activeCyan,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),

              // Send Button - Refined with soft shadows
              GestureDetector(
                onTap: onSend,
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.brandIndigo, AppTheme.activeCyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.brandIndigo.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CustomIconWidget(
                    iconName: 'send',
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
