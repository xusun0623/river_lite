import 'package:flutter/material.dart';

class BlueGrayTabIndicator extends Decoration {
  final TabController tabController;

  const BlueGrayTabIndicator({required this.tabController});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _BlueGrayTabIndicatorPainter(
      decoration: this,
      tabController: tabController,
      onChanged: onChanged,
    );
  }
}

class _BlueGrayTabIndicatorPainter extends BoxPainter {
  final BlueGrayTabIndicator decoration;
  final TabController tabController;

  _BlueGrayTabIndicatorPainter({
    required this.decoration,
    required this.tabController,
    VoidCallback? onChanged,
  }) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect indicatorRect = Offset(
          configuration.size!.width * tabController.animation!.value,
          configuration.size!.height - 8.0, // 调整指示器距离底部的位置
        ) &
        Size(
          configuration.size!.width / tabController.length,
          20.0, // 调整指示器高度
        );

    final Paint paint = Paint();
    paint.color = tabController.indexIsChanging
        ? Colors.blue // 选中状态下的颜色
        : Colors.grey; // 未选中状态下的颜色

    final RRect rRect = RRect.fromRectAndRadius(
      indicatorRect,
      Radius.circular(4.0), // 调整指示器的圆角半径
    );

    canvas.drawRRect(rRect, paint);
  }
}

class TabSizeIndicator extends Decoration {
  final double wantWidth; //传入的指示器宽度，默认20
  const TabSizeIndicator(
      {this.borderSide = const BorderSide(width: 2.0, color: Colors.black87),
      this.insets = EdgeInsets.zero,
      this.wantWidth = 20})
      : assert(borderSide != null),
        assert(insets != null),
        assert(wantWidth != null);
  final BorderSide borderSide; //指示器高度以及颜色 ，默认高度2，颜色蓝
  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration? b, double t) {
    if (b is TabSizeIndicator) {
      return TabSizeIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t)!;
  }

  @override
  _MyUnderlinePainter createBoxPainter([VoidCallback? onChanged]) {
    return _MyUnderlinePainter(this, wantWidth, onChanged!);
  }
}

class _MyUnderlinePainter extends BoxPainter {
  final double wantWidth;
  _MyUnderlinePainter(this.decoration, this.wantWidth, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final TabSizeIndicator decoration;

  BorderSide get borderSide => decoration.borderSide;
  EdgeInsetsGeometry get insets => decoration.insets;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(
      cw - wantWidth / 2,
      indicator.bottom - borderSide.width,
      wantWidth,
      borderSide.width,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator =
        _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0);
    final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.round;
    canvas.drawLine(
      indicator.bottomLeft.translate(0, -12),
      indicator.bottomRight.translate(0, -12),
      paint,
    );
  }
}

class TabSizeRectIndicator extends Decoration {
  final double wantWidth; //传入的指示器宽度，默认20
  const TabSizeRectIndicator(
      {this.borderSide = const BorderSide(width: 2.0, color: Colors.black87),
      this.insets = EdgeInsets.zero,
      this.wantWidth = 20});
  final BorderSide borderSide; //指示器高度以及颜色 ，默认高度2，颜色蓝
  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration? b, double t) {
    if (b is TabSizeIndicator) {
      return TabSizeIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t)!;
  }

  @override
  _MyUnderlineRectPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MyUnderlineRectPainter(this, wantWidth, onChanged!);
  }
}

class _MyUnderlineRectPainter extends BoxPainter {
  final double wantWidth;
  _MyUnderlineRectPainter(
    this.decoration,
    this.wantWidth,
    VoidCallback onChanged,
  ) : super(onChanged);

  final TabSizeRectIndicator decoration;

  BorderSide get borderSide => decoration.borderSide;
  EdgeInsetsGeometry get insets => decoration.insets;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(
      cw - wantWidth / 2,
      indicator.bottom - borderSide.width,
      wantWidth,
      borderSide.width,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator =
        _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0);
    final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.butt;
    canvas.drawLine(
      indicator.bottomLeft.translate(0, -12),
      indicator.bottomRight.translate(0, -12),
      paint,
    );
  }
}
