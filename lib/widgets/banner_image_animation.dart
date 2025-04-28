import 'package:flutter/material.dart';
import 'package:movie_obs/data/dummy/dummy_data.dart';
import 'package:movie_obs/widgets/cache_image.dart';

class BannerImageAnimation extends StatelessWidget {
  const BannerImageAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ImageFadeAnimation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ImageFadeAnimation extends StatefulWidget {
  const ImageFadeAnimation({super.key});

  @override
  State<ImageFadeAnimation> createState() => _ImageFadeAnimationState();
}

class _ImageFadeAnimationState extends State<ImageFadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  void _startAnimation() {
    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          currentIndex = (currentIndex + 1) % imageArray.length;
        });
        _controller.forward();
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
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: FadeTransition(
            opacity: _animation,
            child: cacheImage(
              imageArray[currentIndex],
            ),
          ),
        ),
      ),
    );
  }
}
