// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class SetupScaffold extends StatelessWidget {
  const SetupScaffold({
    Key? key,
    required this.setupChildren,
    required this.body,
  }) : super(key: key);

  final List<Widget> setupChildren;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 315,
            child: _Setup(children: setupChildren),
          ),
          Positioned(
            left: 315,
            top: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}

class _Setup extends StatelessWidget {
  const _Setup({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      dense: true,
      textColor: Colors.white,
      child: Material(
        elevation: 1,
        color: Colors.grey[700],
        child: Scrollbar(
          isAlwaysShown: true,
          child: ListView(
            children: children,
          ),
        ),
      ),
    );
  }
}

class SetupDivider extends StatelessWidget {
  const SetupDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: double.infinity,
      color: Colors.white.withOpacity(0.2),
    );
  }
}

class SetupGroup extends StatelessWidget {
  const SetupGroup({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        ...children,
      ],
    );
  }
}
