import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyExample extends MultiChildRenderObjectWidget {
  MyExample({
    Key? key,
    required List<Widget> children,
  }) : super(key: key, children: children);

  @override
  RenderMyExample createRenderObject(BuildContext context) {
    return RenderMyExample();
  }
}

class MyExampleParentData extends ContainerBoxParentData<RenderBox> {}

class RenderMyExample extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, MyExampleParentData> {
  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! MyExampleParentData) {
      child.parentData = MyExampleParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    for (var child = firstChild; child != null; child = childAfter(child)) {
      child.layout(
        // limit children to a max height of 50
        constraints.copyWith(maxHeight: 50),
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paints all children in order vertically, separated by 50px

    var verticalOffset = .0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      context.paintChild(child, offset + Offset(0, verticalOffset));

      verticalOffset += 50;
    }
  }
}
