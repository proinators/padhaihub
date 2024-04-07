import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/home/cubit/home_cubit.dart';
import 'package:padhaihub/home/routes/routes.dart';


class TabbedHomePage extends StatelessWidget {
  const TabbedHomePage._();

  static Page<void> page() =>
      const MaterialPage<void>(child: TabbedHomePage._());

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          // context.flow<NavData>().update((navData) => navData.copyWith(homeStatus: state.status));
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () =>
                        context.read<AppBloc>().add(AppLogoutRequested()),
                    icon: const Icon(Icons.logout_rounded)
                )
              ],
            ),
            body: PageTransitionSwitcher(
              reverse: state.prevStatus.index - state.status.index > 0,
                transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    ) {
                  return SharedAxisTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  );
                },
                child: generateTabPage(state)
            ),
            bottomNavigationBar: GNav(
              haptic: true,
              activeColor: Theme.of(context).colorScheme.primary,
              curve: Curves.easeInOutSine,
              duration: Duration(milliseconds: 200),
              rippleColor: Theme.of(context).colorScheme.surface,
              tabBackgroundColor: Theme.of(context).colorScheme.onPrimary,
              hoverColor: Theme.of(context).colorScheme.surface.withAlpha(125),
              color: Colors.grey[700],
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              tabMargin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              gap: 8,
              iconSize: 24,
              selectedIndex: context.read<HomeCubit>().state.status.index,
              onTabChange: (index) => context.read<HomeCubit>().changePage(index),
              tabs: context.read<HomeCubit>().getPageIcons().map((e) => GButton(
                icon: e[0],
                text: e[1],
              )).toList(),
            ),
          );
        },
      ),
    );
  }
}
