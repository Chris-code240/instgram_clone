import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration animationDuration;
  final VoidCallback? onEnd;
  final bool isSmallLike;
  const LikeAnimation(
      {super.key,
      required this.child,
      this.animationDuration = const Duration(microseconds: 150),
      required this.isAnimating,
      this.isSmallLike = false,
      this.onEnd});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> scale;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(
            microseconds: widget.animationDuration.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.isSmallLike) {
      await _animationController.forward();
      await _animationController.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
    }
    if (widget.onEnd != null) {
      widget.onEnd!();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
