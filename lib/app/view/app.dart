// import 'package:dynamic_color/dynamic_color.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:padhaihub/src/src.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/config/config.dart';

class App extends StatelessWidget {
  App({
    required AuthenticationRepository authenticationRepository,
    required this.storageRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;
  final StorageRepository storageRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
          storageRepository: storageRepository,
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
    Map<Brightness, ThemeData> themes = themeBuilder(null, null);
    return MaterialApp(
      title: 'PadhaiHub',
      home: FlowBuilder<NavData>(
        state: context.select((AppBloc bloc) => NavData(appStatus: bloc.state.status)),
        onGeneratePages: onGenerateAppViewPages,
      ),
      theme: themes[Brightness.light],
      darkTheme: themes[Brightness.dark],
      debugShowCheckedModeBanner: false,
    );
  }
}