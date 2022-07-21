// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class SetupScaffold extends StatefulWidget {
  const SetupScaffold({
    Key? key,
    required this.setupChildren,
    required this.body,
  }) : super(key: key);

  final List<Widget> setupChildren;
  final Widget body;

  @override
  State<SetupScaffold> createState() => _SetupScaffoldState();
}

class _SetupScaffoldState extends State<SetupScaffold>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<double> _iconTurns;

  bool _collapsed = false;

  @override
  void initState() {
    final Animatable<double> easeInTween = CurveTween(curve: Curves.easeIn);
    final Animatable<double> halfTween = Tween<double>(begin: 0, end: 0.5);

    _animationController = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: this,
    );
    _iconTurns = _animationController.drive(halfTween.chain(easeInTween));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final visibilityIcon = Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: InkResponse(
          onTap: () {
            setState(() => _collapsed = !_collapsed);
            if (_animationController.isCompleted) {
              _animationController.reverse(from: 1);
            } else {
              _animationController.forward(from: 0);
            }
          },
          radius: 20,
          child: RotationTransition(
            turns: _iconTurns,
            child: const Icon(
              Icons.keyboard_arrow_left_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    return Stack(
      children: [
        AnimatedPositioned(
          duration: kThemeAnimationDuration,
          left: 0,
          top: 0,
          bottom: 0,
          width: _collapsed ? 0 : 315,
          child: _Setup(
            controller: _scrollController,
            children: widget.setupChildren,
          ),
        ),
        AnimatedPositioned(
          duration: kThemeAnimationDuration,
          left: _collapsed ? 0 : 315,
          top: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            left: false,
            top: false,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: widget.body,
            ),
          ),
        ),
        AnimatedPositioned(
          duration: kThemeAnimationDuration,
          left: _collapsed ? 0 : 315,
          top: 0,
          child: SafeArea(
            child: visibilityIcon,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class _Setup extends StatelessWidget {
  const _Setup({
    Key? key,
    required this.controller,
    required this.children,
  }) : super(key: key);

  final ScrollController controller;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      child: ListTileTheme(
        dense: true,
        textColor: Colors.white,
        child: Material(
          elevation: 1,
          color: Colors.grey[700],
          child: Scrollbar(
            controller: controller,
            isAlwaysShown: true,
            showTrackOnHover: true,
            interactive: true,
            child: ListView(
              controller: controller,
              children: children,
            ),
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
