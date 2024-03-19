import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _localRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    super.dispose();
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    startLocalVideo();
  }

  Future<void> startLocalVideo() async {
    // Requesting access to the media devices
    final mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };

    try {
      // Create a stream from the camera
      // final stream =
      //     await navigator.mediaDevices.getUserMedia(mediaConstraints);
      final stream = await _getUserMedia();
      setState(() {});

      setState(() {
        _localRenderer.srcObject = stream;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter WebRTC Local Camera'),
        ),
        body: Container(
          alignment: Alignment.center,
          // child: RTCVideoView(_localRenderer, mirror: true),
          child: Container(
            width: 300,
            height: 300,
            alignment: Alignment.center,
            child: RTCVideoView(
              _localRenderer,
              mirror: true,
            ),
          ),
        ),
      ),
    );
  }
}

Future<MediaStream> _getUserMedia({bool onlyStream = false}) async {
  final MediaStream stream = await navigator.mediaDevices.getUserMedia({
    'audio': {
      'sampleRate': '48000',
      'sampleSize': '16',
      'channelCount': '1',
      'mandatory': {
        'googEchoCancellation': 'true',
        'googEchoCancellation2': 'true',
        'googNoiseSuppression': 'true',
        'googNoiseSuppression2': 'true',
        'googAutoGainControl': 'true',
        'googAutoGainControl2': 'true',
        'googDAEchoCancellation': 'true',
        'googTypingNoiseDetection': 'true',
        'googAudioMirroring': 'false',
        'googHighpassFilter': 'true',
      },
    },
    'video': {
      'mandatory': {
        'minHeight': '480',
        'minWidth': '640',
        // 'minFrameRate': '15',
        // 'frameRate': '15',
        // 'height': '480',
        // 'width': '640',
      },
      'facingMode': 'user',
    },
  });

  return stream;
}
