import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountSectionWidget extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;
  final VoidCallback onPrivacySettings;

  const AccountSectionWidget({
    super.key,
    required this.onLogout,
    required this.onDeleteAccount,
    required this.onPrivacySettings,
  });

  @override
  Widget build(BuildContext context) {
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
                iconName: 'account_circle',
                color: AppTheme.activeCyan,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Account',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textHighEmphasisDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // Account options
          Column(
            children: [
              _buildAccountOption(
                icon: 'privacy_tip',
                title: 'Privacy Settings',
                subtitle: 'Manage your data and privacy preferences',
                color: AppTheme.activeCyan,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onPrivacySettings();
                },
              ),
              SizedBox(height: 2.h),
              _buildAccountOption(
                icon: 'security',
                title: 'Security',
                subtitle: 'Password and authentication settings',
                color: AppTheme.successGreen,
                onTap: () {
                  HapticFeedback.lightImpact();
                  // Handle security settings
                },
              ),
              SizedBox(height: 2.h),
              _buildAccountOption(
                icon: 'backup',
                title: 'Data Export',
                subtitle: 'Download your conversation history',
                color: AppTheme.warmGold,
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showDataExportDialog(context);
                },
              ),
              SizedBox(height: 3.h),
              // Divider
              Container(
                height: 1,
                color: AppTheme.softGray.withValues(alpha: 0.2),
              ),
              SizedBox(height: 3.h),
              // Logout option
              _buildAccountOption(
                icon: 'logout',
                title: 'Logout',
                subtitle: 'Sign out of your account',
                color: AppTheme.warmGold,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onLogout();
                },
              ),
              SizedBox(height: 2.h),
              // Delete account option
              _buildAccountOption(
                icon: 'delete_forever',
                title: 'Delete Account',
                subtitle: 'Permanently remove your account and data',
                color: AppTheme.darkTheme.colorScheme.error,
                onTap: () {
                  HapticFeedback.heavyImpact();
                  onDeleteAccount();
                },
                isDestructive: true,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // App version info
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.cardDark.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ZeitWise',
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.textHighEmphasisDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Version 1.0.0 (Beta)',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMediumEmphasisDark,
                      ),
                    ),
                  ],
                ),
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.textMediumEmphasisDark,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOption({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isDestructive
              ? color.withValues(alpha: 0.1)
              : AppTheme.cardDark.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDestructive
                ? color.withValues(alpha: 0.3)
                : AppTheme.softGray.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color:
                          isDestructive ? color : AppTheme.textHighEmphasisDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: isDestructive
                          ? color.withValues(alpha: 0.8)
                          : AppTheme.textMediumEmphasisDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: isDestructive
                  ? color.withValues(alpha: 0.8)
                  : AppTheme.textMediumEmphasisDark,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showDataExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkTheme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          title: Text(
            'Export Data',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textHighEmphasisDark,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose what data you\'d like to export:',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisDark,
                ),
              ),
              SizedBox(height: 2.h),
              _buildExportOption('Conversation History', true),
              _buildExportOption('Achievement Progress', true),
              _buildExportOption('Settings & Preferences', false),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.softGray),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle data export
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Export started. You\'ll receive an email when ready.'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warmGold,
                foregroundColor: AppTheme.primaryNavy,
              ),
              child: const Text('Export'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExportOption(String title, bool isSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isSelected ? 'check_box' : 'check_box_outline_blank',
            color: isSelected ? AppTheme.successGreen : AppTheme.softGray,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisDark,
            ),
          ),
        ],
      ),
    );
  }
}
