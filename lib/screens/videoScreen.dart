 import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'login.dart';  

 class IntroVideoPage extends StatefulWidget {
   const IntroVideoPage({Key? key}) : super(key: key);

   @override
   _IntroVideoPageState createState() => _IntroVideoPageState();
 }

 class _IntroVideoPageState extends State<IntroVideoPage> {
   late VideoPlayerController _controller;
   late Future<void> _initializeVideoPlayerFuture;

   @override
   void initState() {
     super.initState();
     _controller = VideoPlayerController.asset('lib/assets/video/intro.mp4');
     _initializeVideoPlayerFuture = _controller.initialize().then((_) {
        
       setState(() {});
       _controller.play();
     });

  
     _controller.addListener(() {
       if (_controller.value.position == _controller.value.duration) {
      
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(
             builder: (context) => const LoginPage(),
           ),
         );
       }
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
       body: FutureBuilder(
         future: _initializeVideoPlayerFuture,
         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.done) {
             return Center(
               child: AspectRatio(
                 aspectRatio: _controller.value.aspectRatio,
                 child: VideoPlayer(_controller),
               ),
             );
           } else {
             return  Center(child: CircularProgressIndicator());
           }
         },
       ),
     );
   }
 }
