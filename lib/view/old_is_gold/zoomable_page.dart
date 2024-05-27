import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../data/static_method.dart';
import '../../values/colors.dart';

class ZoomPage extends StatefulWidget {
  final List<dynamic> imageUrls;
  final int initialIndex;

  ZoomPage(
      {super.key, required this.imageUrls, this.initialIndex = 0});

  @override
  State<ZoomPage> createState() => _ZoomPageState();
}

class _ZoomPageState extends State<ZoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        backgroundColor: Clr().transparent,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Clr().white,
          ),
        ),
      ),
      body: widget.imageUrls.isNotEmpty
          ? PhotoViewGallery.builder(
        itemCount: widget.imageUrls.length,
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.imageUrls[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            errorBuilder: (context, url, error) =>
                Center(child: STM().loadingPlaceHolder()),
          );
        },
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null ? 0 : null,
          ),
        ),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: widget.initialIndex),
      )
          : Center(child: STM().loadingPlaceHolder()),
    );
  }
}
