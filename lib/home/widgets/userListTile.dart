import 'package:cached_network_image/cached_network_image.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:padhaihub/app/app.dart';

class UserItem extends StatelessWidget {
  const UserItem({super.key, required this.user});

  final types.User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface,
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              user.imageUrl ?? "",
            ),
          ),
        ),
      ),
      title: Text(user.firstName ?? "" ?? ""),
      subtitle: Text(user.metadata?["id"] ?? ""),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text("Start Chat"),
              content: Text("Do you want to start a chat with ${user.firstName ?? ""}?"),
              actions: [
                ElevatedButton(
                  child: Text("Cancel"),
                  onPressed:  () {Navigator.of(dialogContext, rootNavigator: true).pop();},
                ),
                ElevatedButton(
                  child: Text("Continue"),
                  onPressed:  () async {
                    Navigator.of(dialogContext, rootNavigator: true).pop();
                    context.flow<NavData>().update(
                            (navData) => navData.copyWith(room: types.Room(id: "", type: types.RoomType.direct, users: [user]))
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}