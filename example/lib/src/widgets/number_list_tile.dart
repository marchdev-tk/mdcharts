// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class IntListTile extends StatelessWidget {
  const IntListTile({
    Key? key,
    this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

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
          IconButton(
            constraints: const BoxConstraints.tightFor(width: 32),
            splashRadius: 16,
            padding: EdgeInsets.zero,
            hoverColor: Colors.white10,
            onPressed: () => onChanged(value - 1),
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            width: 20,
            child: Center(child: Text(value.toString())),
          ),
          IconButton(
            constraints: const BoxConstraints.tightFor(width: 32),
            splashRadius: 16,
            padding: EdgeInsets.zero,
            hoverColor: Colors.white10,
            onPressed: () => onChanged(value + 1),
            icon: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
