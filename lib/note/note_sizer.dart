import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeReportingWidget extends SingleChildRenderObjectWidget {
  final void Function(Size size) onSizeChanged;

  const SizeReportingWidget({
    Key? key,
    required this.onSizeChanged,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SizeReportingRenderBox(onSizeChanged: onSizeChanged);
  }

  @override
  void updateRenderObject(BuildContext context, SizeReportingRenderBox renderObject) {
    renderObject.onSizeChanged = onSizeChanged;
  }
}

class SizeReportingRenderBox extends RenderProxyBox {
  void Function(Size size) onSizeChanged;

  SizeReportingRenderBox({required this.onSizeChanged});

  @override
  void performLayout() {
    super.performLayout();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onSizeChanged(size);
    });
  }
}
