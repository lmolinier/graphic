import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:graphic/graphic.dart';

/// A painted bitmap shape.
///
class HeatmapBitmapShape extends PolygonShape {
  @override
  bool equalTo(Object other) => other is HeatmapBitmapShape;

  @override
  List<MarkElement> drawGroupPrimitives(
    List<Attributes> group,
    CoordConv coord,
    Offset origin,
  ) {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);

    // Get the step size of y axis.
    // lines have the same height
    var stepY = double.infinity;
    for (var i = 0; i < group.length - 1; i++) {
      final point = group[i].position.last;
      final nextPoint = group[i + 1].position.last;
      final dy = (nextPoint.dy - point.dy).abs();
      if (dy != 0) {
        stepY = stepY < dy ? stepY : dy;
      }
    }
    if (!stepY.isFinite) {
      stepY = 1;
    }
    final biasY = stepY / 2;

    // Now, compute the width and draw the bitmap.
    var leftBound = 0.0;
    var rightBound = 0.0;

    for (var i = 0; i < group.length - 1; i++) {
      final item = group[i];
      final point = group[i].position.last;

      if (point.dx < leftBound) {
        leftBound = 0;
      }
      rightBound = point.dx + (leftBound - point.dx) / 2;

      final style = getPaintStyle(item, false, 0, null, null);
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = style.fillColor!;

      canvas.drawRect(
        Rect.fromPoints(
          coord.convert(Offset(leftBound, point.dy + biasY)),
          coord.convert(Offset(rightBound, point.dy - biasY)),
        ),
        paint,
        // = const Color.fromARGB(0, 250, 1, 1),
      );

      leftBound = rightBound;
    }

    final picture = recorder.endRecording();
    final full = coord.convert(Offset(1, 0));
    final image = picture.toImageSync(
      full.dx.toInt(),
      full.dy.toInt(),
    );
    return [
      ImageElement(
        image: image,
        anchor: Offset.zero,
        defaultAlign: Alignment.bottomRight,
        style: ImageStyle(),
      )
    ];
  }

  @override
  List<MarkElement> drawGroupLabels(
      List<Attributes> group, CoordConv coord, Offset origin) {
    final rst = <MarkElement>[];

    for (var item in group) {
      if (item.label != null && item.label!.haveText) {
        final point = item.position.last;
        rst.add(LabelElement(
          text: item.label!.text!,
          anchor: coord.convert(point),
          defaultAlign: Alignment.center,
          style: item.label!.style,
          tag: item.tag,
        ));
      }
    }

    return rst;
  }
}

class HistoricHeatmapBitmapShape extends HeatmapBitmapShape {
  /// Creates a heatmap where each data is appended to the previous data.
  HistoricHeatmapBitmapShape({
    required this.length,
  }) {
    _history = [];
  }

  /// The length of the history.
  final int length;

  late List<Picture> _history;

  @override
  bool equalTo(Object other) => other is HistoricHeatmapBitmapShape;

  Picture drawLine(List<Attributes> group, CoordConv coord, double height ) {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    
    for (var i = 0; i < group.length - 1; i++) {
      final item = group[i];
      final point = group[i].position.last;
      final nextPoint = group[i + 1].position.last;
      final dx = (nextPoint.dx - point.dx).abs();

      final style = getPaintStyle(item, false, 0, null, null);
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = style.fillColor!;

      canvas.drawRect(
        Rect.fromPoints(
          coord.convert(Offset(point.dx - dx / 2, 1)),
          coord.convert(Offset(point.dx + dx / 2, 1 - height)),
        ),
        paint,
      );
    }

    return recorder.endRecording();
  }

  @override
  List<MarkElement> drawGroupPrimitives(
    List<Attributes> group,
    CoordConv coord,
    Offset origin,
  ) {
    final double height = 1.0;
    final line = drawLine(group, coord, height);
    if(_history.length >= length) {
      _history.removeAt(0);
    }
    _history.add(line);

    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
  
    for (var i = _history.length-1; i >=0 ; i--) {
      final picture = _history[i];
      canvas.drawPicture(picture);
      canvas.translate(0, height);
    }
    
    final full = coord.convert(const Offset(1, 0));
    final picture = recorder.endRecording();
    return [
      ImageElement(
        image: picture.toImageSync(
          full.dx.toInt(),
          full.dy.toInt(),
        ),
        anchor: Offset.zero,
        defaultAlign: Alignment.bottomRight,
        style: ImageStyle(),
      )
    ];
  }
}
