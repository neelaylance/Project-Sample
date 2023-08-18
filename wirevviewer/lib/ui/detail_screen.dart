import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailsScreen extends StatefulWidget {
  String url, title, description;

  DetailsScreen(
      {super.key,
      required this.url,
      required this.title,
      required this.description});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: widget.url,

            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
          ),
          Container(margin:const EdgeInsets.all(8),
            child: Text(
              widget.title,
              style:const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            margin:const EdgeInsets.all(8),
              child: Text(
            widget.description,
            style: const TextStyle(fontSize: 18),
          ))
        ],
      ),
    );
  }
}
