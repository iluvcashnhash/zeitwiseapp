import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final Map<String, dynamic>? persona;
  final bool isTyping;
  final Function(String) onAudioPlay;
  final Function(String, String) onLongPress;
  final bool isPlayingAudio;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.persona,
    required this.isTyping,
    required this.onAudioPlay,
    required this.onLongPress,
    required this.isPlayingAudio,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUser = message['isUser'] ?? false;
    final String messageText = message['text'] ?? '';
    final bool hasAudio = message['hasAudio'] ?? false;
    final String messageId = message['id'] ?? '';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser && persona != null) ...[
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: persona!['color'],
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: persona!['avatar'],
                  width: 8.w,
                  height: 8.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () => onLongPress(messageId, messageText),
              child: Container(
                constraints: BoxConstraints(maxWidth: 75.w),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color:
                      isUser ? AppTheme.brandIndigo : AppTheme.parchmentCream,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser && persona != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: Text(
                          persona!['name'],
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.historicalSepia,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: isTyping
                              ? _buildTypingIndicator()
                              : Text(
                                  messageText,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: isUser
                                        ? Colors.white
                                        : AppTheme.primaryNavy,
                                    height: 1.4,
                                  ),
                                ),
                        ),
                        if (!isUser && hasAudio && !isTyping) ...[
                          SizedBox(width: 2.w),
                          GestureDetector(
                            onTap: () => onAudioPlay(messageId),
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: isPlayingAudio
                                    ? AppTheme.activeCyan.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName:
                                    isPlayingAudio ? 'pause' : 'volume_up',
                                color: AppTheme.historicalSepia,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (!isTyping)
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(
                          _formatTimestamp(message['timestamp']),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: isUser
                                ? Colors.white.withValues(alpha: 0.7)
                                : AppTheme.softGray,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.activeCyan,
              ),
              child: CustomIconWidget(
                iconName: 'person',
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 3; i++) ...[
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600 + (i * 200)),
            tween: Tween(begin: 0.4, end: 1.0),
            builder: (context, value, child) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: AppTheme.softGray.withValues(alpha: value),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
          if (i < 2) SizedBox(width: 1.w),
        ],
      ],
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
