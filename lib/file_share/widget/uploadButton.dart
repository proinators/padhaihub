import 'package:flutter/material.dart';
import 'package:padhaihub/app/app.dart';

class FloatingUploadButton extends StatelessWidget {
  const FloatingUploadButton({super.key, required this.isLoading, required void Function() this.onPressed});

  final bool isLoading;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: (isLoading)
        ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        )
        : Icon(Icons.upload_rounded),
        onPressed: (!isLoading) ? onPressed : (() {}),
    );
  }
}
