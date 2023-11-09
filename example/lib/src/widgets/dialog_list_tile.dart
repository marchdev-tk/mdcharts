// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogListTile extends StatelessWidget {
  const DialogListTile({
    super.key,
    this.title,
    required this.value,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  final Widget? title;
  final String? value;
  final ValueChanged<String?> onChanged;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => _Dialog(
            title: title,
            value: value,
            keyboardType: keyboardType,
          ),
        );

        onChanged(result);
      },
      title: title,
      subtitle: Text(
        value ?? 'no data specified',
        style: const TextStyle(
          fontSize: 9,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _Dialog extends StatefulWidget {
  const _Dialog({
    required this.title,
    required this.value,
    required this.keyboardType,
  });

  final Widget? title;
  final String? value;
  final TextInputType keyboardType;

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value ?? '');
    super.initState();
  }

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
      content: TextField(
        autofocus: true,
        controller: _controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: widget.keyboardType,
        inputFormatters: [
          if (widget.keyboardType.decimal == true)
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
          else if (widget.keyboardType == TextInputType.number)
            FilteringTextInputFormatter.digitsOnly,
        ],
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
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Save'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
