import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/config/config.dart';
import 'package:padhaihub/home/home.dart';
import 'package:padhaihub/src/src.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    DateFormat weekdayFormat = DateFormat("EEEE");
    DateFormat timeFormat = DateFormat.jm();

    final today = DateTime.timestamp().toLocal();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<List<types.Room>>(
            stream: FirebaseChatCore.instance.rooms(),
            initialData: const [],
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // if (snapshot.data?.first.id == "") {
                //   return LoadingWidget();
                // }
                return ListView.separated(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return AnimationConfiguration.staggeredList(
                        position: 2 * index,
                        duration: Duration(milliseconds: STAGGERED_DURATION.inMilliseconds~/2),
                        child: SlideAnimation(
                          verticalOffset: STAGGERED_SLIDE_OFFSET,
                          child: FadeInAnimation(
                            child: ChatListTile(room: context.read<AppBloc>().storageRepository.publicRoom!, unread: false, formattedDateTime: ""),
                          ),
                        ),
                      );
                    }
                    index--;
                    final dateTime = DateTime.fromMillisecondsSinceEpoch(snapshot.data![index].updatedAt ?? 0);
                    String formattedDateTime;
                    if (today.difference(dateTime).inDays >= 7) {
                      formattedDateTime = dateFormat.format(dateTime);
                    } else if (today.day != dateTime.day) {
                      formattedDateTime = weekdayFormat.format(dateTime);
                    } else {
                      formattedDateTime = timeFormat.format(dateTime);
                    }
                    bool unread;
                    try {
                      unread = (snapshot.data![index].metadata?[context.read<AppBloc>().state.userModel.id]) < snapshot.data![index].updatedAt ?? double.infinity;
                    } catch (e) {
                      unread = false;
                    }
                    return AnimationConfiguration.staggeredList(
                      position: 2 * index,
                      duration: Duration(milliseconds: STAGGERED_DURATION.inMilliseconds~/2),
                      child: SlideAnimation(
                        verticalOffset: STAGGERED_SLIDE_OFFSET,
                        child: FadeInAnimation(
                          child: ChatListTile(room: snapshot.data![index], unread: unread, formattedDateTime: formattedDateTime),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: 2 * index + 1,
                      duration: Duration(milliseconds: STAGGERED_DURATION.inMilliseconds~/2),
                      child: FadeInAnimation(
                        child: const Divider(
                          thickness: 1,
                          height: 20,
                        ),
                      ),
                    );
                  },
                  itemCount: (snapshot.data?.length ?? 0) + 1,
                );
              } else {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Wow, such empty"),
                    ],
                  )
                );
              }
            }
          )
        );
      },
    );;
  }
}
