import 'package:flutter/material.dart';
import 'package:flutter_video_player/component/slider_video_progress_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_video_player/component/custom_video_progress_indicator.dart';

class SliderVideoPlayer extends StatefulWidget {
  @override
  _SliderVideoPlayerState createState() => _SliderVideoPlayerState();
}

class _SliderVideoPlayerState extends State<SliderVideoPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    )..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return Container();

    return Scaffold(
      appBar: AppBar(
        title: Text('Slider Video Player'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _controller.value.initialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
            Positioned(
              bottom: 0,
              height: 15,
              width: MediaQuery.of(context).size.width,
              child: SliderVideoProgressIndicator(_controller),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: _PlayerSpeedButton(
                controller: _controller,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PlayerSpeedButton extends StatefulWidget {
  const _PlayerSpeedButton({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  _PlayerSpeedButtonState createState() => _PlayerSpeedButtonState();
}

class _PlayerSpeedButtonState extends State<_PlayerSpeedButton> {
  double speed = 1.0;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 64,
      height: 64,
      child: RaisedButton(
        child: Text(
          // 'x$speed',
          '▶||',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        shape: CircleBorder(),
        onPressed: () {
          // speed = speed > 1.5 ? 0.5 : speed + 0.5;
          // widget.controller.setPlaybackSpeed(speed);
          setState(() {
            if (widget.controller.value.isPlaying) {
              widget.controller.pause();
            } else {
              // If the video is paused, play it.
              widget.controller.play();
            }
          });
        },
      ),
    );
  }
}
