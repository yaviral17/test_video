import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_video/videoEditorrr.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  VideoPlayerWidget({required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late ChewieController _controller;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    _controller = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 9 / 16, // Adjust as needed
      autoPlay: true,
      looping: false, // Set to true if you want the video to loop
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  // stop video on back button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: !_controller.videoPlayerController.value.isInitialized
            ? Chewie(controller: _controller)
            : CircularProgressIndicator(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Video Picker App'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => _pickVideo(context), // Pass the context here
            child: Text('Pick Video'),
          ),
        ),
      ),
    );
  }

  Future<void> _pickVideo(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null) {
      String videoPath = result.files.single.path!;
      Get.to(() => VideoEditor(file: File(videoPath)));
    }
  }
}
