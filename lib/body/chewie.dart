import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewieBody extends StatefulWidget {
  @override
  _ChewieBodyState createState() => _ChewieBodyState();
}

class _ChewieBodyState extends State<ChewieBody> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoInitialize: true,
          autoPlay: true,
          looping: true,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        );
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chewie'),
      ),
      body: Center(
        child: _chewieController != null
            ? Chewie(
                controller: _chewieController,
              )
            : Container(),
      ),
    );
  }
}
