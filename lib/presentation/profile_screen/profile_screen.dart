import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_section_widget.dart';
import './widgets/persona_store_widget.dart';
import './widgets/plan_badge_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/streak_counter_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Alex Chen",
    "email": "alex.chen@zeitwise.com",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "plan": "Free",
    "streak": 7,
    "totalConversations": 23,
    "achievements": [
      {"name": "First Chat", "icon": "chat", "unlocked": true},
      {
        "name": "Week Warrior",
        "icon": "local_fire_department",
        "unlocked": true
      },
      {"name": "Wisdom Seeker", "icon": "psychology", "unlocked": false},
      {"name": "Philosophy Master", "icon": "school", "unlocked": false}
    ],
    "settings": {
      "notifications": true,
      "ttsEnabled": true,
      "darkMode": true,
      "hapticFeedback": true
    }
  };

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _closeProfile() {
    HapticFeedback.lightImpact();
    _slideController.reverse().then((_) {
      _fadeController.reverse().then((_) {
        Navigator.of(context).pop();
      });
    });
  }

  void _showLogoutDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkTheme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          title: Text(
            'Logout',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textHighEmphasisDark,
            ),
          ),
          content: Text(
            'Are you sure you want to logout? Your progress will be saved.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisDark,
            ),
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
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login-screen',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warmGold,
                foregroundColor: AppTheme.primaryNavy,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkTheme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          title: Text(
            'Delete Account',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.darkTheme.colorScheme.error,
            ),
          ),
          content: Text(
            'This action cannot be undone. All your conversations, progress, and achievements will be permanently deleted.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisDark,
            ),
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
                // Handle account deletion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkTheme.colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Backdrop
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Container(
                color: Colors.black.withValues(alpha: _fadeAnimation.value),
                child: GestureDetector(
                  onTap: _closeProfile,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              );
            },
          ),
          // Bottom Sheet
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return SlideTransition(
                position: _slideAnimation,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: 85.h,
                      minHeight: 60.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundDark,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag indicator
                        Container(
                          margin: EdgeInsets.only(top: 2.h),
                          width: 12.w,
                          height: 0.5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.softGray.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Close button
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Profile',
                                style: AppTheme
                                    .darkTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  color: AppTheme.textHighEmphasisDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: _closeProfile,
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceDark,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'close',
                                    color: AppTheme.textMediumEmphasisDark,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Content
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 2.h),
                                // Profile Header
                                ProfileHeaderWidget(userData: userData),
                                SizedBox(height: 3.h),
                                // Plan Badge
                                PlanBadgeWidget(
                                  plan: userData["plan"] as String,
                                  onUpgrade: () {
                                    HapticFeedback.mediumImpact();
                                    // Handle upgrade
                                  },
                                ),
                                SizedBox(height: 3.h),
                                // Streak Counter
                                StreakCounterWidget(
                                  streak: userData["streak"] as int,
                                  totalConversations:
                                      userData["totalConversations"] as int,
                                  achievements:
                                      userData["achievements"] as List,
                                ),
                                SizedBox(height: 3.h),
                                // Persona Store
                                PersonaStoreWidget(),
                                SizedBox(height: 3.h),
                                // Settings
                                SettingsSectionWidget(
                                  settings: userData["settings"]
                                      as Map<String, dynamic>,
                                  onSettingChanged: (key, value) {
                                    HapticFeedback.selectionClick();
                                    setState(() {
                                      (userData["settings"]
                                          as Map<String, dynamic>)[key] = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 3.h),
                                // Account Section
                                AccountSectionWidget(
                                  onLogout: _showLogoutDialog,
                                  onDeleteAccount: _showDeleteAccountDialog,
                                  onPrivacySettings: () {
                                    HapticFeedback.lightImpact();
                                    // Handle privacy settings
                                  },
                                ),
                                SizedBox(height: 4.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
