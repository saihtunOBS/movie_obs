import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/ads_bloc.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:provider/provider.dart';

class AdsImageAnimation extends StatelessWidget {
  const AdsImageAnimation({super.key});

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
    var bloc = context.read<AdsBloc>();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startAnimation(bloc);
  }

  void _startAnimation(AdsBloc bloc) {
    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          currentIndex = (currentIndex + 1) % bloc.adsLists.length;
        });
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdsBloc(context: context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Consumer<AdsBloc>(
          builder:
              (context, bloc, child) =>
                  bloc.adsLists.isEmpty
                      ? SizedBox.shrink()
                      : SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        width: double.infinity,
                        child: FadeTransition(
                          opacity: _animation,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: cacheImage(
                              bloc.adsLists[currentIndex].image ?? '',
                              boxFit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
        ),
      ),
    );
  }
}
