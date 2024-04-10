import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/config/config.dart';
import 'package:padhaihub/home/home.dart';
import 'package:padhaihub/src/src.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return StreamBuilder<types.User>(
          stream: FirebaseChatCore.instance.currUser(),
          builder: (context, snapshot) {
            types.User? user = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                    childAnimationBuilder: (widget) => SlideAnimation(
                      duration: STAGGERED_DURATION,
                      verticalOffset: STAGGERED_SLIDE_OFFSET,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                  Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.surface,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  user?.imageUrl ?? "",
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              user?.firstName ?? "",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 8),
                    child: const Text(
                      "Stats",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  if (user != null) Text("Number of files shared: ${user.metadata?["files_shared"] ?? 0}"),
                ]
                ),
              ),
            );
          }
        );
      },
    );;
  }
}
