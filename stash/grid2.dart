import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class GridCard {
  final Widget child;
  final Offset position;

  GridCard({required this.child, required this.position});
}

class InfiniteGridWithCards extends MultiChildRenderObjectWidget {
  final Offset offset;
  final List<GridCard> cards;

  InfiniteGridWithCards({
    Key? key,
    required this.offset,
    required this.cards,
  }) : super(key: key, children: cards.map((card) => card.child).toList());

  @override
  RenderInfiniteGridWithCards createRenderObject(BuildContext context) {
    return RenderInfiniteGridWithCards(
      offset: offset,
      cardPositions: cards.map((card) => card.position).toList(),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderInfiniteGridWithCards renderObject) {
    renderObject
      ..offset = offset
      ..cardPositions = cards.map((card) => card.position).toList();
  }
}

class InfiniteGridParentData extends ContainerBoxParentData<RenderBox> {
  late Offset initialPosition;
}

class RenderInfiniteGridWithCards extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, InfiniteGridParentData> {
  RenderInfiniteGridWithCards({// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',canvsca
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        // Mouse dragging enabled for this demo
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: TwoDimensionalGridView(
        diagonalDragBehavior: DiagonalDragBehavior.free,
        delegate: TwoDimensionalChildBuilderDelegate(
            maxXIndex: 9,
            maxYIndex: 9,
            builder: (BuildContext context, ChildVicinity vicinity) {
              return Container(
                color: vicinity.xIndex.isEven && vicinity.yIndex.isEven
                    ? Colors.amber[50]
                    : (vicinity.xIndex.isOdd && vicinity.yIndex.isOdd
                        ? Colors.purple[50]
                        : null),
                height: 200,
                width: 200,
                child: Center(
                    child: Text(
                        'Row ${vicinity.yIndex}: Column ${vicinity.xIndex}')),
              );
            }),
      ),
    );
  }
}

class TwoDimensionalGridView extends TwoDimensionalScrollView {
  const TwoDimensionalGridView({
    super.key,
    super.primary,
    super.mainAxis = Axis.vertical,
    super.verticalDetails = const ScrollableDetails.vertical(),
    super.horizontalDetails = const ScrollableDetails.horizontal(),
    required TwoDimensionalChildBuilderDelegate delegate,
    super.cacheExtent,
    super.diagonalDragBehavior = DiagonalDragBehavior.none,
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return TwoDimensionalGridViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalDetails.direction,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalDetails.direction,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }
}

class TwoDimensionalGridViewport extends TwoDimensionalViewport {
  const TwoDimensionalGridViewport({
    super.key,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required TwoDimensionalChildBuilderDelegate super.delegate,
    required super.mainAxis,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  });

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return RenderTwoDimensionalGridViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      childManager: context as TwoDimensionalChildManager,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTwoDimensionalGridViewport renderObject,
  ) {
    renderObject
      ..horizontalOffset = horizontalOffset
      ..horizontalAxisDirection = horizontalAxisDirection
      ..verticalOffset = verticalOffset
      ..verticalAxisDirection = verticalAxisDirection
      ..mainAxis = mainAxis
      ..delegate = delegate
      ..cacheExtent = cacheExtent
      ..clipBehavior = clipBehavior;
  }
}

class RenderTwoDimensionalGridViewport extends RenderTwoDimensionalViewport {
  RenderTwoDimensionalGridViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required TwoDimensionalChildBuilderDelegate delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  @override
  void layoutChildSequence() {
    final double horizontalPixels = horizontalOffset.pixels;
    final double verticalPixels = verticalOffset.pixels;
    final double viewportWidth = viewportDimension.width + cacheExtent;
    final double viewportHeight = viewportDimension.height + cacheExtent;
    final TwoDimensionalChildBuilderDelegate builderDelegate =
        delegate as TwoDimensionalChildBuilderDelegate;

    final int maxRowIndex = builderDelegate.maxYIndex!;
    final int maxColumnIndex = builderDelegate.maxXIndex!;

    final int leadingColumn = math.max((horizontalPixels / 200).floor(), 0);
    final int leadingRow = math.max((verticalPixels / 200).floor(), 0);
    final int trailingColumn = math.min(
      ((horizontalPixels + viewportWidth) / 200).ceil(),
      maxColumnIndex,
    );
    final int trailingRow = math.min(
      ((verticalPixels + viewportHeight) / 200).ceil(),
      maxRowIndex,
    );

    double xLayoutOffset = (leadingColumn * 200) - horizontalOffset.pixels;
    for (int column = leadingColumn; column <= trailingColumn; column++) {
      double yLayoutOffset = (leadingRow * 200) - verticalOffset.pixels;
      for (int row = leadingRow; row <= trailingRow; row++) {
        final ChildVicinity vicinity =
            ChildVicinity(xIndex: column, yIndex: row);
        final RenderBox child = buildOrObtainChildFor(vicinity)!;
        child.layout(constraints.loosen());

        // Subclasses only need to set the normalized layout offset. The super
        // class adjusts for reversed axes.
        parentDataOf(child).layoutOffset = Offset(xLayoutOffset, yLayoutOffset);
        yLayoutOffset += 200;
      }
      xLayoutOffset += 200;
    }

    // Set the min and max scroll extents for each axis.
    final double verticalExtent = 200 * (maxRowIndex + 1);
    verticalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          verticalExtent - viewportDimension.height, 0.0, double.infinity),
    );
    final double horizontalExtent = 200 * (maxColumnIndex + 1);
    horizontalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          horizontalExtent - viewportDimension.width, 0.0, double.infinity),
    );
    // Super class handles garbage collection too!
  }
}

    required Offset offset,
    required List<Offset> cardPositions,
  })  : _offset = offset,
        _cardPositions = cardPositions; 

  Offset _offset;
  List<Offset> _cardPositions;

  set offset(Offset value) {
    if (_offset == value) return;
    _offset = value;
    markNeedsPaint();
  }

  set cardPositions(List<Offset> value) {
    if (_cardPositions == value) return;
    _cardPositions = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! InfiniteGridParentData) {
      child.parentData = InfiniteGridParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    RenderBox? child = firstChild;
    for (int i = 0; i < _cardPositions.length; i++) {
      if (child != null) {
        final parentData = child.parentData as InfiniteGridParentData;
        parentData.initialPosition = _cardPositions[i];
        child.layout(constraints.loosen(), parentUsesSize: true);
        child = childAfter(child);
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Draw grid
    final canvas = context.canvas;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    final spacing = 50.0;
    final dotRadius = 2.0;

    double startX = (_offset.dx % spacing) - spacing;
    double startY = (_offset.dy % spacing) - spacing;

    for (double x = startX; x < size.width + spacing; x += spacing) {
      for (double y = startY; y < size.height + spacing; y += spacing) {
        canvas.drawCircle(offset + Offset(x, y), dotRadius, paint);
      }
    }

    // Draw children (cards)
    RenderBox? child = firstChild;
    while (child != null) {
      final parentData = child.parentData as InfiniteGridParentData;
      final childOffset = parentData.initialPosition + _offset;
      if (_isVisible(childOffset)) {
        context.paintChild(child, childOffset + offset);
      }
      child = childAfter(child);
    }
  }

  bool _isVisible(Offset position) {
    return position.dx > -100 &&
        position.dx < size.width + 100 &&
        position.dy > -100 &&
        position.dy < size.height + 100;
  }

  // @override
  // bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
  //   RenderBox? child = lastChild;
  //   while (child != null) {
  //     final parentData = child.parentData as InfiniteGridParentData;
  //     final childOffset = parentData.initialPosition + _offset;
  //     final isHit = result.addWithPaintOffset(
  //       offset: childOffset,
  //       position: position,
  //       hitTest: (BoxHitTestResult result, Offset transformed) {
  //         return child!.hitTest(result, position: transformed);
  //       },
  //     );
  //     if (isHit) return true;
  //     child = childBefore(child);
  //   }
  //   return false;
  // }
}

class InfiniteGridWidget extends StatefulWidget {
  final List<GridCard> cards;

  InfiniteGridWidget({required this.cards});

  @override
  _InfiniteGridWidgetState createState() => _InfiniteGridWidgetState();
}

class _InfiniteGridWidgetState extends State<InfiniteGridWidget> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset += details.delta;
        });
      },
      child: InfiniteGridWithCards(
        offset: _offset,
        cards: widget.cards,
      ),
    );
  }
}

// class my extends RenderObject {
//   @override
//   void performLayout() {
//     // Implement performLayout logic here
//   }

//   @override
//   void paint(PaintingContext context, Offset offset) {
//     // Implement paint logic here
//   }

//   @override
//   void attach(PipelineOwner owner) {
//     // TODO: implement attach
//     super.attach(owner);
//   }

//   @override
//   void performResize() {
//     // TODO: implement performResize
//   }
// }
