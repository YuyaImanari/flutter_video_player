import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerBody extends StatefulWidget {
  @override
  _VideoPlayerBodyState createState() => _VideoPlayerBodyState();
}

class _VideoPlayerBodyState extends State<VideoPlayerBody> {
  VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    )..initialize().then((_) {
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
    _controller.seekTo(Duration.zero).then((_) => _controller.play());

    print(_controller.value.size.width);

    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
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
            height: 32,
            width: MediaQuery.of(context).size.width,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: _PlayerSpeedButton(
              controller: _controller,
            ),
          )
        ],
      )),
    );
  }
}

class _PlayerSpeedButton extends StatefulWidget {
  const _PlayerSpeedButton({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  __PlayerSpeedButtonState createState() => __PlayerSpeedButtonState();
}

class __PlayerSpeedButtonState extends State<_PlayerSpeedButton> {
  double speed = 1.0;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 64,
      height: 64,
      child: RaisedButton(
        child: Text(
          'x$speed',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        shape: CircleBorder(),
        onPressed: () {
          speed = speed > 1.5 ? 0.5 : speed + 0.5;
          widget.controller.setPlaybackSpeed(speed);
          setState(() {});
        },
      ),
    );
  }
}
