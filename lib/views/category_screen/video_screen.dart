import 'package:e_community/consts/consts.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  final String? videoLink;
  const Video({super.key, this.videoLink});

  @override
  State<Video> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Video> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoLink.toString()))
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _controller.value.isInitialized
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    30.heightBox,
                    FloatingActionButton(
                      backgroundColor: redColor,
                      foregroundColor: white,
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: Icon(_controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                    )
                  ],
                )
              : loadingIndicator(circleColor: white)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
