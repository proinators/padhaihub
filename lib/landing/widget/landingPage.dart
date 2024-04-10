import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:formz/formz.dart';
import 'package:padhaihub/config/config.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:padhaihub/landing/landing.dart';

class LandingPageWidget extends StatefulWidget {
  const LandingPageWidget({super.key});

  @override
  State<LandingPageWidget> createState() => _LandingPageWidgetState();
}

class _LandingPageWidgetState extends State<LandingPageWidget> {

  final Image logoImage = Image.asset(LOGO_IMAGE_PATH);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(new AssetImage(LOGO_IMAGE_PATH), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LandingCubit, LandingState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: Container(
        child: Center(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
                childAnimationBuilder: (widget) => ScaleAnimation(
                  scale: STAGGERED_SCALE_OFFSET,
                  duration: STAGGERED_DURATION_LANDING,
                  child: FadeInAnimation(
                    duration: STAGGERED_DURATION_LANDING,
                    child: widget,
                  ),
                ),
                children: [
                  Image(
                    image: AssetImage("assets/icon/icon.png"),
                    fit: BoxFit.fitHeight,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "PadhaiHub",
                      style: TextStyle(
                          fontSize: 36
                      ),
                    ),
                  ),
                  GoogleLoginButton(),
                ]
            ),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}