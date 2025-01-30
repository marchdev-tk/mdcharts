// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/painting.dart';

/// Text painter utility.
class MDTextPainter {
  /// Constructs an instance of [MDTextPainter].
  MDTextPainter(TextSpan textSpan) {
    _textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
  }

  late TextPainter _textPainter;
  bool _needsLayout = true;

  /// Gets size of the provided [TextSpan].
  Size get size {
    _textPainter.layout();
    _needsLayout = false;
    return _textPainter.size;
  }

  /// Paints text.
  void paint(Canvas canvas, Offset offset) {
    if (_needsLayout) {
      _textPainter.layout();
    }
    _textPainter.paint(canvas, offset);
  }

  /// Releases the resources associated with this painter.
  ///
  /// After disposal this painter is unusable.
  void dispose() {
    _textPainter.dispose();
  }
}
