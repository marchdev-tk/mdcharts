// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/painting.dart';

class MDTextPainter {
  MDTextPainter(TextSpan textSpan) {
    textPainter = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
  }

  late TextPainter textPainter;
  bool _needsLayout = true;

  Size get size {
    textPainter.layout();
    _needsLayout = false;
    return textPainter.size;
  }

  void paint(Canvas canvas, Offset offset) {
    if (_needsLayout) {
      textPainter.layout();
    }
    textPainter.paint(canvas, offset);
  }
}
