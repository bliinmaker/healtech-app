import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPreview extends StatelessWidget {
  const PhotoPreview({super.key, required this.file, this.overlay});

  final XFile file;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Image.file(
            File(file.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
          ),
          if (overlay != null)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: Center(child: overlay),
              ),
            ),
        ],
      ),
    );
  }
}
