import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(String, bool) onSettingChanged;

  const SettingsSectionWidget({
    super.key,
    required this.settings,
    required this.onSettingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingItems = [
      {
        "key": "notifications",
        "title": "Push Notifications",
        "subtitle": "Get notified about new content and reminders",
        "icon": "notifications",
        "value": settings["notifications"] as bool? ?? true,
      },
      {
        "key": "ttsEnabled",
        "title": "Text-to-Speech",
        "subtitle": "Enable voice playback for persona messages",
        "icon": "volume_up",
        "value": settings["ttsEnabled"] as bool? ?? true,
      },
      {
        "key": "darkMode",
        "title": "Dark Mode",
        "subtitle": "Optimized for evening mindful sessions",
        "icon": "dark_mode",
        "value": settings["darkMode"] as bool? ?? true,
      },
      {
        "key": "hapticFeedback",
        "title": "Haptic Feedback",
        "subtitle": "Feel interactions through device vibrations",
        "icon": "vibration",
        "value": settings["hapticFeedback"] as bool? ?? true,
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.softGray.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.activeCyan,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Settings',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textHighEmphasisDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // Settings items
          Column(
            children: settingItems.map((item) {
              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: item["icon"] as String,
                        color: AppTheme.activeCyan,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    // Title and subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["title"] as String,
                            style: AppTheme.darkTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.textHighEmphasisDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            item["subtitle"] as String,
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textMediumEmphasisDark,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Switch
                    Switch(
                      value: item["value"] as bool,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        onSettingChanged(item["key"] as String, value);
                      },
                      activeColor: AppTheme.warmGold,
                      activeTrackColor:
                          AppTheme.warmGold.withValues(alpha: 0.3),
                      inactiveThumbColor: AppTheme.softGray,
                      inactiveTrackColor:
                          AppTheme.softGray.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          // Additional settings
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.cardDark.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.softGray.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildSettingRow(
                  icon: 'language',
                  title: 'Language',
                  subtitle: 'English (US)',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Handle language selection
                  },
                ),
                Divider(
                  color: AppTheme.softGray.withValues(alpha: 0.2),
                  height: 2.h,
                ),
                _buildSettingRow(
                  icon: 'storage',
                  title: 'Storage & Cache',
                  subtitle: 'Manage app data',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Handle storage settings
                  },
                ),
                Divider(
                  color: AppTheme.softGray.withValues(alpha: 0.2),
                  height: 2.h,
                ),
                _buildSettingRow(
                  icon: 'help',
                  title: 'Help & Support',
                  subtitle: 'Get assistance',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Handle help
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.textMediumEmphasisDark,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.textHighEmphasisDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisDark,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textMediumEmphasisDark,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
