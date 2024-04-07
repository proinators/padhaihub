import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:padhaihub/config/config.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:padhaihub/landing/landing.dart';

class LandingPageWidget extends StatelessWidget {
  const LandingPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final track = MovieTween()
      ..scene(
        begin: const Duration(milliseconds: 0),
        end: const Duration(milliseconds: 10000),
      ).tween(
          'color1',
          ColorTween(
              begin: Theme.of(context).extension<CustomColors>()!.landing1,
              end: Theme.of(context).extension<CustomColors>()!.landing2
          )
      )
      ..scene(
        begin: const Duration(milliseconds: 0),
        end: const Duration(milliseconds: 10000),
      ).tween(
        'color2',
        ColorTween(
            begin: Theme.of(context).extension<CustomColors>()!.landing2,
            end: Theme.of(context).extension<CustomColors>()!.landing1
        )
      );

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
      child: LoopAnimationBuilder<Movie>(
        tween: track, // Pass in tween
        duration: track.duration, // Obtain duration
        builder: (context, value, child) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [value.get('color1'), value.get('color2')]
            )
          ),
          child: Center(
            child: Column(
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
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
        ),
      ),
    );
  }
}