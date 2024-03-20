import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
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
          child: StreamBuilder<List<types.Room>>(
            stream: FirebaseChatCore.instance.rooms(),
            initialData: const [types.Room(id: "", type: types.RoomType.direct, users: [])],
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                if (snapshot.data?.first.id == "") {
                  return LoadingWidget();
                }
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surface,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              snapshot.data![index].imageUrl ?? "",
                            ),
                          ),
                        ),
                      ),
                      title: Text(snapshot.data![index].name ?? ""),
                      trailing: Text(DateTime.fromMillisecondsSinceEpoch(snapshot.data![index].updatedAt ?? 0).toString()),
                      onTap: () {
                        context.flow<NavData>().update((navData) => navData.copyWith(room: snapshot.data![index]));
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: snapshot.data?.length ?? 0,
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
