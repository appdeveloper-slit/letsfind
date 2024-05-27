import 'package:flutter/material.dart';

import '../values/dimens.dart';

class ImageViewPage extends StatefulWidget {
  final img, type;

  const ImageViewPage({super.key, this.type, this.img});

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    print("Image :: ${widget.img}");

    return Scaffold(
      body: Center(
        child: widget.type == 'file'
            ? ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dim().d12),
                ),
                child: Image.file(
                  widget.img,
                  height: 600,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dim().d12),
                ),
                child: Image.network(
                  widget.img.toString(),
                  height: 600,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
      ),
    );
  }
}
