import 'package:flutter/material.dart';
import 'package:porfolio_project/screens/get_started.dart';
import 'package:video_player/video_player.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Replace these with the paths to your local videos
  final List<String> videoPaths = [
    'assets/welcome1.mp4',
    'assets/welcome2.mp4',
    'assets/welcome3.mp4',
  ];

  VideoPlayerController? _currentController;
  VideoPlayerController? _nextController;

  int _currentIndex = 0;
  bool _isTransitioning = false;
  bool _showHomeScreen = false;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    // We intentionally don't initialize the video in initState anymore.
    // Modern web browsers block video initialization and autoplay
    // unless the user has explicitly interacted with the page first.
  }

  Future<void> _startSequence() async {
    setState(() {
      _hasStarted = true;
    });
    await _initVideo(0);
  }

  Future<void> _initVideo(int index) async {
    _currentController = VideoPlayerController.asset(videoPaths[index]);
    try {
      await _currentController!.initialize();
    } catch (e) {
      debugPrint("Error initializing video: $e");
    }

    if (!mounted) return;

    setState(() {});
    _currentController!.play();
    _currentController!.addListener(_videoListener);

    if (index + 1 < videoPaths.length) {
      _nextController = VideoPlayerController.asset(videoPaths[index + 1]);
      try {
        await _nextController!.initialize();
      } catch (e) {
        debugPrint("Error preloading next video: $e");
      }
    }
  }

  void _videoListener() {
    if (_isTransitioning || _currentController == null) return;

    final value = _currentController!.value;
    if (value.isInitialized &&
        !value.isPlaying &&
        value.position >= value.duration) {
      _transitionToNext();
    }
  }

  Future<void> _transitionToNext() async {
    _isTransitioning = true;
    _currentController!.removeListener(_videoListener);

    final oldController = _currentController;

    setState(() {
      _currentIndex++;
      if (_currentIndex < videoPaths.length) {
        _currentController = _nextController;
      } else {
        _showHomeScreen = true;
        _currentController = null;
      }
    });

    if (_currentController != null) {
      _currentController!.play();
      _currentController!.addListener(_videoListener);

      if (_currentIndex + 1 < videoPaths.length) {
        _nextController = VideoPlayerController.asset(
          videoPaths[_currentIndex + 1],
        );
        _nextController!.initialize().catchError((e) {
          debugPrint("Error preloading video: $e");
        });
      } else {
        _nextController = null;
      }
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      oldController?.dispose();
    });

    await Future.delayed(const Duration(milliseconds: 100));
    _isTransitioning = false;
  }

  @override
  void dispose() {
    _currentController?.dispose();
    _nextController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: !_hasStarted
              ? GetStartedScreen(startSequence: _startSequence)
              : _showHomeScreen
              ? const HomeScreen(key: ValueKey('home_screen'))
              : _currentController != null &&
                    _currentController!.value.isInitialized
              ? AspectRatio(
                  key: ValueKey<int>(_currentIndex),
                  aspectRatio: _currentController!.value.aspectRatio,
                  child: VideoPlayer(_currentController!),
                )
              : const CircularProgressIndicator(key: ValueKey('loading')),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey.shade900, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_rounded, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Welcome Home',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'All videos have finished playing.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
