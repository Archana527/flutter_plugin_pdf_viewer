import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_plugin_pdf_viewer/src/zoom.dart';
import 'package:photo_view/photo_view.dart';

class PDFPage extends StatefulWidget {
  final String imgPath;
  final int num;
  final Function(double) onZoomChanged;
  final int zoomSteps;
  final double minScale;
  final double maxScale;
  final double panLimit;
  PDFPage(
    this.imgPath,
    this.num, {
    this.onZoomChanged,
    this.zoomSteps = 3,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.panLimit = 1.0,
  });

  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  ImageProvider provider;
  ImageStream _resolver;
  ImageStreamListener _listener;
  bool _repainting = false;


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
      decoration: null,
      child: CustomZoomableWidget(
        onZoomChanged: widget.onZoomChanged,
        zoomSteps: widget.zoomSteps ?? 3,
        minScale: widget.minScale ?? 1.0,
        panLimit: widget.panLimit ?? 1.0,
        maxScale: widget.maxScale ?? 5.0,
        autoCenter: true,
        child: Image(image: provider),
      )
    );
  }
}
