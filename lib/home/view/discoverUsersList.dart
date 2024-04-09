import 'package:cached_network_image/cached_network_image.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/home/home.dart';
import 'package:searchable_listview/searchable_listview.dart';

class DiscoverUserTab extends StatelessWidget {
  const DiscoverUserTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<List<types.User>>(
            stream: FirebaseChatCore.instance.users(),
            initialData: const [types.User(id: "")],
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                if (snapshot.data?.first.id == "") {
                  return LoadingWidget();
                }
                // return ListView.separated(
                //   itemBuilder: (context, index) {
                //     return UserItem(user: snapshot.data![index]);
                //   },
                //   separatorBuilder: (context, index) {
                //     return Divider();
                //   },
                //   itemCount: snapshot.data?.length ?? 0,
                // );
                return SearchableList(
                  initialList: snapshot.data!,
                  builder: (_, int index, types.User user) {
                    return UserItem(user: user);
                  },
                  filter: (value) => snapshot.data!.where(
                          (element) =>
                            (element.firstName?.toLowerCase().contains(value.toLowerCase()) ?? false)
                              || (element.metadata?["id"].toString().contains(value.toLowerCase()) ?? false)
                  ).toList(),
                  emptyWidget: EmptyWidget(),
                  inputDecoration: InputDecoration(
                    labelText: "Search for a user",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              } else {
                return const EmptyWidget();
              }
            }
          )
        );
      },
    );
  }
}


