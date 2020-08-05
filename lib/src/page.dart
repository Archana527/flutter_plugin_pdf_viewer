import 'dart:io';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class PDFPage extends StatefulWidget {
  final String imgPath;
  final int num;

  PDFPage(this.imgPath, this.num);

  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  ImageProvider provider;

  Matrix4 matrix = Matrix4.identity();
  Matrix4 zerada = Matrix4.identity();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repaint();
  }

  @override
  void didUpdateWidget(PDFPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imgPath != widget.imgPath) {
      _repaint();
    }
  }

  _repaint() {
    provider = FileImage(File(widget.imgPath));
    final resolver = provider.resolve(createLocalImageConfiguration(context));
    resolver.addListener(ImageStreamListener((imgInfo, alreadyPainted) {
      if (!alreadyPainted) setState(() {});
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Container(
                child: Center(
                    child: GestureZoomBox(
      maxScale: 10.0,
      doubleTapScale: 1.0,
      duration: Duration(milliseconds: 200),
      onPressed: () => Navigator.pop(context),
      child: Image(
        image: provider,
      ),
    )))));
  }
}
