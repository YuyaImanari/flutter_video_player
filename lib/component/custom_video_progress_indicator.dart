import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class _VideoScrubber extends StatefulWidget {
  _VideoScrubber({
    @required this.child,
    @required this.controller,
  });

  final Widget child;
  final VideoPlayerController controller;

  @override
  _VideoScrubberState createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<_VideoScrubber> {
  bool _controllerWasPlaying = false;

  VideoPlayerController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final RenderBox box = context.findRenderObject();
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = controller.value.duration * relative;
      controller.seekTo(position);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        _controllerWasPlaying = controller.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying) {
          controller.play();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
    );
  }
}

class CustomVideoProgressIndicator extends StatefulWidget {
  CustomVideoProgressIndicator(
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
  _CustomVideoProgressIndicatorState createState() => _CustomVideoProgressIndicatorState();
}

class _CustomVideoProgressIndicatorState extends State<CustomVideoProgressIndicator> {
  _CustomVideoProgressIndicatorState() {
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
    int duration = 1;
    int position = 0;
    if (controller.value.initialized) {
      duration = controller.value.duration.inMilliseconds;
      position = controller.value.position.inMilliseconds;
    }

    return _VideoScrubber(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              Container(
                width: constraints.maxWidth,
                height: widget.barHeight,
                color: widget.backgroundColor,
              ),
              Container(
                width: constraints.maxWidth * position / duration,
                height: widget.barHeight,
                color: widget.playedColor,
              ),
              Positioned(
                left: constraints.maxWidth * position / duration - widget.circleSize / 2,
                child: Container(
                  width: widget.circleSize,
                  height: widget.circleSize,
                  decoration: BoxDecoration(
                    color: widget.playedColor,
                    borderRadius: BorderRadius.circular(widget.circleSize / 2),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      controller: controller,
    );
  }
}
