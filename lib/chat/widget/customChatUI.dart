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
    required this.user
  });

  final List<types.Message> messages;
  final void Function(types.PartialText) onSendPressed;
  final void Function(void Function(bool)) onAttachmentPressed;
  final void Function(BuildContext, types.Message) onMessageTap;
  final void Function(BuildContext, types.Message) onMessageLongPress;
  final void Function(BuildContext, types.Message) onMessageDoubleTap;
  final types.User user;

  @override
  State<CustomChat> createState() => _CustomChatState();
}

class _CustomChatState extends State<CustomChat> {
  TextEditingController textController = TextEditingController();
  bool _isAttachmentUploading = false;

  void setUploadingStatus(bool val) {
    setState(() {
      _isAttachmentUploading = val;
    });
  }

  void modifiedAttachmentPressed() {
    widget.onAttachmentPressed(setUploadingStatus);
  }

  @override
  Widget build(BuildContext context) {
    return ui.Chat(
      messages: widget.messages,
      onSendPressed: widget.onSendPressed,
      onAttachmentPressed: modifiedAttachmentPressed,
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
      isAttachmentUploading: _isAttachmentUploading,
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
