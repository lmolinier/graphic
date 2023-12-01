import 'dart:ui';

import 'package:flutter/painting.dart';

import 'element.dart';

/// The style of [PictureElement].
class PictureStyle extends BlockStyle {
  /// Creates an image style.
  PictureStyle({
    this.blendMode,
    Offset? offset,
    double? rotation,
    Alignment? align,
  }) : super(
          offset: offset,
          rotation: rotation,
          align: align,
        );

  /// The blend mode of the image.
  final BlendMode? blendMode;

  @override
  PictureStyle lerpFrom(covariant PictureStyle from, double t) => PictureStyle(
        blendMode: blendMode,
        offset: Offset.lerp(from.offset, offset, t),
        rotation: lerpDouble(from.rotation, rotation, t),
        align: Alignment.lerp(from.align, align, t),
      );

  @override
  bool operator ==(Object other) =>
      other is PictureStyle && super == other && blendMode == other.blendMode;
}

/// An picture element.
class PictureElement extends BlockElement<PictureStyle> {
  /// Creates an image element.
  PictureElement({
    required this.picture,
    required Offset anchor,
    Alignment defaultAlign = Alignment.center,
    required PictureStyle style,
    String? tag,
  }) : super(
          anchor: anchor,
          defaultAlign: defaultAlign,
          style: style,
          tag: tag,
        ) {
    }

  /// The pircture to display.
  final Picture picture;

  @override
  void draw(Canvas canvas) => canvas.drawPicture(picture);

  @override
  PictureElement lerpFrom(covariant PictureElement from, double t) => PictureElement(
        picture: picture,
        anchor: Offset.lerp(from.anchor, anchor, t)!,
        defaultAlign: Alignment.lerp(from.defaultAlign, defaultAlign, t)!,
        style: style.lerpFrom(from.style, t),
        tag: tag,
      );

  @override
  bool operator ==(Object other) =>
      other is PictureElement && super == other && picture == other.picture;
}
