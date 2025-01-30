// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  const Grid({
    super.key,
    required this.rows,
    required this.columns,
    required this.children,
  });

  final int rows;
  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows; i++)
          Expanded(
            child: Row(
              children: [
                for (var j = 0; j < columns; j++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: children[i + j + (i > 0 ? 1 : 0)],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
