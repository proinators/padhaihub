import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/home/home.dart';
import 'package:padhaihub/landing/landing.dart';

List<Page<dynamic>> onGenerateAppViewPages(
    AppStatus state,
    List<Page<dynamic>> pages,
    ) {
  if (kDebugMode)
    print("Entered App View Page Generator");
  switch (state) {
    case AppStatus.authenticated:
      return [TabbedHomePage.page()];
    case AppStatus.unauthenticated:
      return [LandingPage.page()];
    case AppStatus.initial:
      return [LoadingPage.page()];
  }
}