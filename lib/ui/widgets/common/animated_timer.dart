import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constant.dart';
import '../../../core/constants/app_text_styles.dart';

class AnimatedTimer extends StatefulWidget {
  final int seconds;
  final double size;

  const AnimatedTimer({super.key, required this.seconds, this.size = 120});

  @override
  State<AnimatedTimer> createState() => _AnimatedTimerState();
}

class _AnimatedTimerState extends State<AnimatedTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Color _getTimerColor() {
    if (widget.seconds > AppConstants.seuilVert) {
      return AppColors.vertSuccess;
    } else if (widget.seconds > AppConstants.seuilOrange) {
      return AppColors.orangeAttention;
    } else if (widget.seconds > AppConstants.seuilRouge) {
      return Colors.orangeAccent;
    } else {
      return AppColors.rougeErreur;
    }
  }

  double _getProgress() {
    return widget.seconds / AppConstants.dureeParMot;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.animationMoyenne,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: _getProgress(),
      end: _getProgress(),
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds) {
      _controller.forward(from: 0);
      _animation = Tween<double>(
        begin: oldWidget.seconds / AppConstants.dureeParMot,
        end: _getProgress(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Anneau de fond
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 3),
              ),
            ),

            // Anneau progressif
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: 6,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(_getTimerColor()),
              ),
            ),

            // Texte du temps
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(widget.seconds ~/ 60).toString().padLeft(2, '0')}',
                  style: AppTextStyles.chronometer.copyWith(
                    fontSize: widget.size * 0.3,
                    color: _getTimerColor(),
                  ),
                ),
                Text(
                  '${(widget.seconds % 60).toString().padLeft(2, '0')}',
                  style: AppTextStyles.chronometer.copyWith(
                    fontSize: widget.size * 0.3,
                    color: _getTimerColor(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
