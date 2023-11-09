// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class IntListTile extends StatelessWidget {
  const IntListTile({
    super.key,
    this.title,
    required this.value,
    required this.onChanged,
  });

  final Widget? title;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkResponse(
            radius: 16,
            hoverColor: Colors.white10,
            onTap: () => onChanged(value - 1),
            onLongPress: () => onChanged(value - 10),
            child: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            width: 28,
            child: Center(child: Text(value.toString())),
          ),
          InkResponse(
            radius: 16,
            hoverColor: Colors.white10,
            onTap: () => onChanged(value + 1),
            onLongPress: () => onChanged(value + 10),
            child: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
