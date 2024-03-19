import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:padhaihub/landing/landing.dart';
import 'package:padhaihub/src/src.dart';

class LandingPage extends StatelessWidget {
  const LandingPage._();

  static Page<void> page() => const MaterialPage<void>(child: LandingPage._());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => LandingCubit(context.read<AuthenticationRepository>()),
          child: const LandingPageWidget(),
        ),
      ),
    );
  }
}
