// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

final _selected = BehaviorSubject<int>.seeded(0);

class ExampleScaffold extends StatelessWidget {
  const ExampleScaffold({
    super.key,
    required this.tabs,
  });

  final Map<String, Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: _AppMenu(tabs: tabs.keys.toList()),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF418FDE), Color(0xFF00468C)],
          ),
        ),
        child: StreamBuilder<int>(
          stream: _selected,
          initialData: _selected.value,
          builder: (context, selected) {
            return IndexedStack(
              index: selected.requireData,
              children: tabs.values.toList(),
            );
          },
        ),
      ),
    );
  }
}

class _AppMenu extends StatelessWidget implements PreferredSizeWidget {
  const _AppMenu({
    required this.tabs,
  });

  final List<String> tabs;

  @override
  Size get preferredSize => const Size.fromHeight(32);

  @override
  Widget build(BuildContext context) {
    Widget buildTab(String tab) {
      return StreamBuilder<int>(
        stream: _selected,
        initialData: _selected.value,
        builder: (context, selected) {
          final index = tabs.indexOf(tab);

          return InkWell(
            hoverColor: Colors.white10,
            onTap: () => _selected.add(index),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
              child: Text(
                tab,
                style: TextStyle(
                  height: 1,
                  fontSize: 14,
                  color: selected.requireData == index
                      ? Colors.blue
                      : Colors.white,
                ),
              ),
            ),
          );
        },
      );
    }

    return Material(
      color: Colors.grey[800],
      child: SafeArea(
        child: Row(
          children: tabs.map(buildTab).toList(),
        ),
      ),
    );
  }
}
