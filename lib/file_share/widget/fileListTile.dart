import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:padhaihub/file_share/cubit/file_share_cubit.dart';

class FileListTile extends StatelessWidget {
  const FileListTile({super.key, required this.message});

  final types.FileMessage message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<FileShareCubit>().onNoteTap(context, message);
      },
      child: Card(
        child: Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                      child: Text(
                        message.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                      child: Text(
                          (context.read<FileShareCubit>().state.authUser?.id == message.author.id)
                          ? "You"
                          : message.author.firstName ?? "Unknown",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontStyle: FontStyle.italic
                          ),
                      ),
                    ),
                  ],
                ),
              ),
              if(message.author.id == context.read<FileShareCubit>().state.authUser?.id) IconButton(
                  onPressed: () {
                    context.read<FileShareCubit>().onMoreTap(context, message);
                  },
                  icon: Icon(
                    Icons.more_vert_rounded
                  ),
              )
            ],
          ),
        ),
      ),
    );
    return Card(
      child: ListTile(
        leading: Text(
            message.name,
            style: Theme.of(context).textTheme.labelMedium,
        ),
        subtitle: Text(message.author.firstName ?? "Unknown"),
      ),
    );
  }
}
