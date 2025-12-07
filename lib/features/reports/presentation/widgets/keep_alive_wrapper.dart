import 'package:flutter/material.dart';

/// A wrapper widget that keeps its child alive when used in TabBarView
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(
      context,
    ); // Must call super.build when using AutomaticKeepAliveClientMixin
    return widget.child;
  }
}
