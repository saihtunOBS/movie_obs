import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:movie_obs/data/dummy/dummy_data.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/widgets/cache_image.dart';

late final AnimationController controller;

class BannerImageAnimation extends StatelessWidget {
  const BannerImageAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ImageScaleAnimation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ImageScaleAnimation extends StatefulWidget {
  const ImageScaleAnimation({super.key});

  @override
  State<ImageScaleAnimation> createState() => _ImageScaleAnimationState();
}

class _ImageScaleAnimationState extends State<ImageScaleAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: 1000), () {
      controller.forward();
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 3), () {
          controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        if (_animation.value == 0) {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              currentIndex = (currentIndex + 1) % imageArray.length;
            });
            controller.forward();
          });
        } else {
          setState(() {
            currentIndex = (currentIndex + 1) % imageArray.length;
          });
          controller.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // Animate from full screen to small circle
            final width = lerpDouble(screenWidth, 120, _animation.value)!;
            final height = lerpDouble(getDeviceType() == 'phone' ? 250 : 350, 120, _animation.value)!;
            final borderRadius = lerpDouble(0, height / 2, _animation.value)!;

            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: SizedBox(
                width: width,
                height: height,
                child: cacheImage(imageArray[currentIndex]),
              ),
            );
          },
        ),
      ),
    );
  }
}
