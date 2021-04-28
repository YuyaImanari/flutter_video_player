import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SliderVideoProgressIndicator extends StatefulWidget {
  SliderVideoProgressIndicator(
    this.controller, {
    this.barHeight = 3.0,
    this.circleSize = 15.0,
    this.playedColor = const Color(0xffFF2C54),
    this.backgroundColor = const Color(0xffFFFFFF),
  });

  final VideoPlayerController controller;
  final double barHeight;
  final double circleSize;
  final Color playedColor;
  final Color backgroundColor;

  @override
  _SliderVideoProgressIndicatorState createState() => _SliderVideoProgressIndicatorState();
}

class _SliderVideoProgressIndicatorState extends State<SliderVideoProgressIndicator> {
  _SliderVideoProgressIndicatorState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  VoidCallback listener;

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    double duration = 1;
    double position = 0;
    if (controller.value.initialized) {
      duration = controller.value.duration.inMilliseconds.toDouble();
      position = controller.value.position.inMilliseconds.toDouble();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          child: Slider(
            value: position,
            min: 0,
            max: duration,
            activeColor: widget.playedColor,
            inactiveColor: widget.backgroundColor,
            onChanged: (double value) {
              setState(() {
                controller.seekTo(controller.value.duration * (value / duration));
              });
            },
          ),
        );
      },
    );
  }
}
