import 'package:flutter/material.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreenComponent extends StatelessWidget {
  final String imagePath;

  ImagePreviewScreenComponent({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: PhotoView(
            imageProvider: loadImage(imagePath),
            backgroundDecoration: BoxDecoration(color: Colors.black),
          ),
        ),
      ),
    );
  }

  ImageProvider loadImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    } else if (path.startsWith('/')) {
      return FileImage(File(path));
    } else {
      return AssetImage(path);
    }
  }
}

class ImageWidget extends StatelessWidget {
  final String imagePath;

  ImageWidget({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
              builder: (_) =>
                  ImagePreviewScreenComponent(imagePath: imagePath)),
        );
      },
      child: loadImageWidget(imagePath),
    );
  }

  Widget loadImageWidget(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(path, fit: BoxFit.cover);
    } else if (path.startsWith('/')) {
      return Image.file(File(path), fit: BoxFit.cover);
    } else {
      return Image.asset(path, fit: BoxFit.cover);
    }
  }
}
