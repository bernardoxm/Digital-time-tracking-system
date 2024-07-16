//CONTROLLER DO VIDIO INICIAL> 
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class IntroVideoScreen extends StatefulWidget {
  @override
  _IntroVideoScreenState createState() => _IntroVideoScreenState();
}

final videoboll = false;

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/intro.mp4')
      ..initialize().then((_) {
        // INICIALIZAR O VIDEO 
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
