import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/home/home.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Hi, ${context.read<AppBloc>().state.user.name}",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
        );
      },
    );;
  }
}
