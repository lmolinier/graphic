import 'dart:math';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:graphic/graphic.dart';
import 'package:graphic/src/coord/coord.dart';
import 'package:graphic/src/coord/polar.dart';
import 'package:graphic/src/coord/rect.dart';
import 'package:graphic/src/dataflow/tuple.dart';
import 'package:graphic/src/graffiti/element/label.dart';
import 'package:graphic/src/graffiti/element/polygon.dart';
import 'package:graphic/src/graffiti/element/rect.dart';
import 'package:graphic/src/graffiti/element/sector.dart';
import 'package:graphic/src/mark/polygon.dart';
import 'package:graphic/src/graffiti/element/element.dart';
import 'package:graphic/src/shape/polygon.dart';
import 'package:graphic/src/util/collection.dart';

import 'util/style.dart';
import 'partition.dart';

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
          stepY = min(stepY, dy);
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
      rightBound = point.dx + (leftBound - point.dx)/2;
      
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

    return [
      PictureElement(
        picture: recorder.endRecording(),
        anchor: origin,
        style: PictureStyle(),
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
  });

  /// The length of the history.
  final int length;

  Image? _lastImage;

  @override
  bool equalTo(Object other) => other is HistoricHeatmapBitmapShape;

  @override
  List<MarkElement> drawGroupPrimitives(
    List<Attributes> group,
    CoordConv coord,
    Offset origin,
  ) {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);

    var leftBound = 0.0;
    var rightBound = 0.0;

    for (var i = 0; i < group.length - 1; i++) {
      final item = group[i];
      final point = group[i].position.last;

      rightBound = point.dx + (leftBound - point.dx)/2;
      
      final style = getPaintStyle(item, false, 0, null, null);
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = style.fillColor!;

      canvas.drawRect(
        Rect.fromPoints(
          coord.convert(Offset(leftBound, 1)),
          coord.convert(Offset(rightBound, 0)),
        ),
        paint,
        // = const Color.fromARGB(0, 250, 1, 1),
      );

      leftBound = rightBound;
    }

    var lineHeight = coord.region.height / length;  
    if (_lastImage != null) {
      canvas.drawImage(_lastImage!,
        Offset(0, lineHeight), 
        Paint(),
      );
    }
    
    final picture = recorder.endRecording();
    _lastImage = picture.toImageSync(
          /* no real matter of the size here, must be bigger than
           * the coord though
           */
          coord.region.width.toInt()*2, 
          coord.region.height.toInt()*2,
        ); 
    return [
      PictureElement(
        picture: picture,
        anchor: origin,
        style: PictureStyle(),
      )
    ];
  }
}