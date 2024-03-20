import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/config/config.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage._();

  static Page<void> page() => const MaterialPage<void>(child: LoadingPage._());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingWidget(),
    );
  }
}
