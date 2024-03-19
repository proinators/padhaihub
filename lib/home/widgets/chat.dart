import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/home/home.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                title: Text("Tile 1"),
              ),
              ListTile(
                title: Text("Tile 2"),
              ),
            ],
          )
        );
      },
    );;
  }
}
