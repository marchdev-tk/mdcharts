// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorListTile extends StatelessWidget {
  const ColorListTile({
    super.key,
    this.title,
    required this.value,
    required this.onChanged,
  });

  final Widget? title;
  final Color value;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => _Dialog(
            title: title,
            value: value,
          ),
        );

        onChanged(result ?? Colors.transparent);
      },
      title: title,
      trailing: Container(
        width: 18,
        height: 18,
        color: value,
      ),
    );
  }
}

class _Dialog extends StatefulWidget {
  const _Dialog({
    required this.title,
    required this.value,
  });

  final Widget? title;
  final Color value;

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  Color? _selectedColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[700],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      title: DefaultTextStyle.merge(
        style: const TextStyle(color: Colors.white),
        child: widget.title ?? const Text('Set new value'),
      ),
      content: IntrinsicHeight(
        child: ColorPicker(
          pickerColor: _selectedColor ?? widget.value,
          onColorChanged: (color) => setState(() => _selectedColor = color),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white),
          ),
          onPressed: Navigator.of(context).pop,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Clear'),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white),
          ),
          onPressed: _selectedColor == null
              ? null
              : () => Navigator.of(context).pop(_selectedColor!),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Save'),
          ),
        ),
      ],
    );
  }
}
