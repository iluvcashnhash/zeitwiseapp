import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AudioWaveformWidget extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onStop;

  const AudioWaveformWidget({
    super.key,
    required this.isPlaying,
    required this.onStop,
  });

  @override
  State<AudioWaveformWidget> createState() => _AudioWaveformWidgetState();
}

class _AudioWaveformWidgetState extends State<AudioWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late List<AnimationController> _barControllers;
  late List<Animation<double>> _barAnimations;

  final List<double> _waveHeights = [
    0.3,
    0.7,
    0.4,
    0.9,
    0.6,
    0.8,
    0.5,
    0.7,
    0.3,
    0.6
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _barControllers = List.generate(
      _waveHeights.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 100)),
        vsync: this,
      ),
    );

    _barAnimations = _barControllers.map((controller) {
      return Tween<double>(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    if (widget.isPlaying) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(AudioWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startAnimation();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _stopAnimation();
    }
  }

  void _startAnimation() {
    _waveController.repeat();
    for (var controller in _barControllers) {
      controller.repeat(reverse: true);
    }
  }

  void _stopAnimation() {
    _waveController.stop();
    for (var controller in _barControllers) {
      controller.stop();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    for (var controller in _barControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.softGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),

          // Audio controls and waveform
          Row(
            children: [
              // Stop button
              GestureDetector(
                onTap: widget.onStop,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.activeCyan,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'stop',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // Waveform visualization
              Expanded(
                child: SizedBox(
                  height: 8.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(_waveHeights.length, (index) {
                      return AnimatedBuilder(
                        animation: _barAnimations[index],
                        builder: (context, child) {
                          return Container(
                            width: 1.w,
                            height: 8.h *
                                _waveHeights[index] *
                                _barAnimations[index].value,
                            decoration: BoxDecoration(
                              color: AppTheme.warmGold,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // Time indicator
              Text(
                '0:03',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.softGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
