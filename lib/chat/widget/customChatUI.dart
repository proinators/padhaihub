import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as ui;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class CustomChat extends StatefulWidget {
  const CustomChat({
    super.key,
    required this.messages,
    required this.onSendPressed,
    required this.onAttachmentPressed,
    required this.onMessageTap,
    required this.onMessageLongPress,
    required this.onMessageDoubleTap,
    required this.user,
    required this.isLoading
  });

  final List<types.Message> messages;
  final void Function(types.PartialText) onSendPressed;
  final void Function() onAttachmentPressed;
  final void Function(BuildContext, types.Message) onMessageTap;
  final void Function(BuildContext, types.Message) onMessageLongPress;
  final void Function(BuildContext, types.Message) onMessageDoubleTap;
  final types.User user;
  final bool isLoading;

  @override
  State<CustomChat> createState() => _CustomChatState();
}

class _CustomChatState extends State<CustomChat> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ui.Chat(
      messages: widget.messages,
      onSendPressed: widget.onSendPressed,
      onAttachmentPressed: widget.onAttachmentPressed,
      onMessageTap: widget.onMessageTap,
      onMessageLongPress: widget.onMessageLongPress,
      onMessageDoubleTap: widget.onMessageDoubleTap,
      theme: (Theme.of(context).brightness == Brightness.light)
          ? ui.DefaultChatTheme(
        inputBackgroundColor: Theme.of(context).colorScheme.primary,
      )
          : ui.DarkChatTheme(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        inputBackgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      isAttachmentUploading: widget.isLoading,
      inputOptions: ui.InputOptions(
        sendButtonVisibilityMode: ui.SendButtonVisibilityMode.editing,
        onTextChanged: (text) {
          setState(() {
            textController.text = text;
          });
        },
        textEditingController: textController,
      ),
      user: widget.user,
    );
  }
}
