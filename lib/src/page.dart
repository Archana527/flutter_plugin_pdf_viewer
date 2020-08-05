import 'dart:io';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
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
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            matrix = zerada;
          });
        },
        child: MatrixGestureDetector(
          shouldRotate: false,
          onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
            setState(() {
              matrix = m;
            });
          },
          child: Transform(
            transform: matrix,
            child: Image(
              image: provider,
            ),
          ),
        ),
      ),
    ));
  }
}
