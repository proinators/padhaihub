import 'package:cached_network_image/cached_network_image.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/config/config.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({super.key, required this.room, required this.unread, required this.formattedDateTime});

  final types.Room room;
  final bool unread;
  final String formattedDateTime;

  @override
  Widget build(BuildContext context) {
    bool isPublicRoom = room.id == PUBLIC_ROOM_ID;
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface,
          image: (!isPublicRoom)
          ? DecorationImage(
            image: CachedNetworkImageProvider(
              room.imageUrl ?? "",
            ),
          )
          : null,
        ),
        child: (!isPublicRoom)
        ? null
        : Icon(Icons.book_rounded),
      ),
      title: Text(
        (!isPublicRoom) ? (room.name ?? "") : "Public Notes",
        style: TextStyle(
            fontWeight: (unread || isPublicRoom) ? FontWeight.bold : FontWeight.normal,
            color: (!isPublicRoom) ? null : Theme.of(context).colorScheme.secondary
        ),
      ),
      trailing: Text(
        formattedDateTime,
        style: TextStyle(
          color: (unread) ? Theme.of(context).colorScheme.tertiary : null,
        ),
      ),
      onTap: () {
        context.flow<NavData>().update((navData) => navData.copyWith(room: room));
      },
    );
  }
}
