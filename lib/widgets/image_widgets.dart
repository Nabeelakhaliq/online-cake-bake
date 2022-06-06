import 'package:flutter/material.dart';

Widget customImageWidgets(String imagePath) {
  return Image.asset(imagePath);
}

Widget buildImage(context, String imageUrl) {
  return SizedBox(
    height: MediaQuery.of(context).size.width / 2.5,
    child: ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, Widget child, ImageChunkEvent? progress) {
          if (progress == null) {
            return child;
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: CircularProgressIndicator(value: progress.expectedTotalBytes != null ? (progress.cumulativeBytesLoaded / progress.expectedTotalBytes!) : null),
            ),
          );
        },
      ),
    ),
  );
}