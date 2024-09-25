import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/* 折叠组件 */
class ExpansionCustom extends StatefulWidget {
  const ExpansionCustom({
    Key? key,
    required this.title,
    required this.onExpansionChanged,
    this.children = const <Widget>[],
    this.initiallyExpanded = false,
    required this.isExpanded,
    required this.padding,
  }) : super(key: key);

  final Widget title;
  final ValueChanged<bool> onExpansionChanged;
  final List<Widget> children;
  final bool initiallyExpanded;
  final bool isExpanded;
  final EdgeInsetsGeometry padding;

  @override
  _ExpansionCustomState createState() => _ExpansionCustomState();
}

class _ExpansionCustomState extends State<ExpansionCustom>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.ease);

  late AnimationController _controller;
  Animation<double>? _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);

    _isExpanded =
        PageStorage.of(context).readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  diyHandle() {
    setState(() {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {});
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    widget.onExpansionChanged(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: _handleTap,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              padding: widget.padding,
              child: widget.title,
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor?.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    diyHandle();
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}
