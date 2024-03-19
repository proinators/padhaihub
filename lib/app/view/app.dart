import 'package:dynamic_color/dynamic_color.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app.dart';
import '../../config/theme.dart';

import '../../src/authRepo.dart';
import '../bloc/app_bloc.dart';
import '../routes/routes.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    // return ThemeBuilder(
    //   builder: (lightData, darkData, context) => MaterialApp(
    //     title: 'PadhaiHub',
    //     theme: lightData,
    //     darkTheme: darkData,
    //     home: FlowBuilder<AppStatus>(
    //       state: context.select((AppBloc bloc) => bloc.state.status),
    //       onGeneratePages: onGenerateAppViewPages,
    //     ),
    //     debugShowCheckedModeBanner: false,
    //   ),
    // );

    // return DynamicColorBuilder(
    //   builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic)  {
    //     Map<Brightness, ThemeData> themes = themeBuilder(lightDynamic, darkDynamic);
    //     return MaterialApp(
    //       title: 'PadhaiHub',
    //       home: FlowBuilder<AppStatus>(
    //         state: context.select((AppBloc bloc) => bloc.state.status),
    //         onGeneratePages: onGenerateAppViewPages,
    //       ),
    //       theme: themes[Brightness.light],
    //       darkTheme: themes[Brightness.dark],
    //       debugShowCheckedModeBanner: false,
    //     );
    //   },
    // );
    Map<Brightness, ThemeData> themes = themeBuilder(null, null);
    return MaterialApp(
      title: 'PadhaiHub',
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
      theme: themes[Brightness.light],
      darkTheme: themes[Brightness.dark],
      debugShowCheckedModeBanner: false,
    );
  }
}