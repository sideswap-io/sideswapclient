library;

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/sideswap_slider/sideswap_slider_theme.dart';
import 'package:sideswap/providers/limit_review_order_providers.dart';

enum SideSwapSliderAxisInteraction { left, right, center }

class SideSwapSlider extends ConsumerStatefulWidget {
  const SideSwapSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.marks,
    this.hatchMarkLabels,
    this.themeData,
  }) : assert(min <= max),
       assert(
         value >= min && value <= max,
         'value must be between min and max. value: $value, min: $min, max: $max',
       );

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final List<SideSwapSliderTrackMark>? marks;
  final List<SideSwapSliderHatchMarkLabel>? hatchMarkLabels;
  final SideSwapSliderThemeData? themeData;

  @override
  ConsumerState<SideSwapSlider> createState() => SideSwapSliderState();
}

class DeleteKeyActiveIntent extends Intent {}

class ArrowLeftKeyActiveIntent extends Intent {}

class ArrowRightKeyActiveIntent extends Intent {}

class SideSwapSliderState extends ConsumerState<SideSwapSlider> {
  bool _focused = false;
  late final Map<Type, Action<Intent>> _actionMap;
  final Map<ShortcutActivator, Intent>
  _shortcutMap = <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.delete): DeleteKeyActiveIntent(),
    SingleActivator(LogicalKeyboardKey.arrowLeft): ArrowLeftKeyActiveIntent(),
    SingleActivator(LogicalKeyboardKey.arrowRight): ArrowRightKeyActiveIntent(),
  };
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _actionMap = <Type, Action<Intent>>{
      DeleteKeyActiveIntent: CallbackAction<Intent>(
        onInvoke: (Intent intent) => _deleteKeyAction(),
      ),
      ArrowLeftKeyActiveIntent: CallbackAction<Intent>(
        onInvoke: (intent) => _arrowLeftAction(),
      ),
      ArrowRightKeyActiveIntent: CallbackAction<Intent>(
        onInvoke: (intent) => _arrowRightAction(),
      ),
    };
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _deleteKeyAction() {
    if (_focused) {
      widget.onChanged.call(0.5);
    }
  }

  void _arrowLeftAction() {
    if (!_focused) {
      return;
    }

    final trackingRangeConverter = ref.read(trackingRangeConverterProvider);
    final rangedValue = trackingRangeConverter.toRangeWithPrecision(
      widget.value,
      precision: 8,
      origMinValue: widget.min,
      origMaxValue: widget.max,
      newMin: 0.0,
      newMax: 1.0,
    );

    final newValue = (rangedValue - 0.001) < 0 ? .0 : (rangedValue - 0.001);

    widget.onChanged.call(newValue);
  }

  void _arrowRightAction() {
    if (!_focused) {
      return;
    }

    final trackingRangeConverter = ref.read(trackingRangeConverterProvider);
    final rangedValue = trackingRangeConverter.toRangeWithPrecision(
      widget.value,
      precision: 8,
      origMinValue: widget.min,
      origMaxValue: widget.max,
      newMin: 0.0,
      newMax: 1.0,
    );

    final newValue = (rangedValue + 0.001) > 1.0 ? 1.0 : (rangedValue + 0.001);

    widget.onChanged.call(newValue);
  }

  void _handleFocusHighlight(bool value) {
    setState(() {
      _focused = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SideSwapSliderThemeData defaults = _DefaultSideSwapSliderThemeData(
      context,
    );

    SideSwapSliderThemeData themeData = widget.themeData ?? defaults;
    themeData = themeData.copyWith(
      trackShape: widget.themeData?.trackShape ?? defaults.trackShape,
      trackMarkShape:
          widget.themeData?.trackMarkShape ?? defaults.trackMarkShape,
      thumbShape: widget.themeData?.thumbShape ?? defaults.thumbShape,
      hatchMarkShape:
          widget.themeData?.hatchMarkShape ?? defaults.hatchMarkShape,
      trackHeight: widget.themeData?.trackHeight ?? defaults.trackHeight,
      activeTrackColor:
          widget.themeData?.activeTrackColor ?? defaults.activeTrackColor,
      inactiveTrackColor:
          widget.themeData?.inactiveTrackColor ?? defaults.inactiveTrackColor,
      activeTrackMarkColor:
          widget.themeData?.activeTrackMarkColor ??
          defaults.activeTrackMarkColor,
      inactiveTrackMarkColor:
          widget.themeData?.inactiveTrackMarkColor ??
          defaults.inactiveTrackMarkColor,
      axisInteraction:
          widget.themeData?.axisInteraction ?? defaults.axisInteraction,
    );

    return FocusableActionDetector(
      actions: _actionMap,
      shortcuts: _shortcutMap,
      focusNode: _focusNode,
      onShowFocusHighlight: _handleFocusHighlight,
      child: SideSwapSliderRenderObjectWidget(
        focusNode: _focusNode,
        value: widget.value,
        onChanged: widget.onChanged,
        min: widget.min,
        max: widget.max,
        marks: widget.marks,
        hatchMarkLabels: widget.hatchMarkLabels,
        themeData: themeData,
        state: this,
      ),
    );
  }
}

class _DefaultSideSwapSliderThemeData extends SideSwapSliderThemeData {
  _DefaultSideSwapSliderThemeData(this.context) : super(trackHeight: 2.0);

  BuildContext context;

  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color? get activeTrackColor => _colors.primary;

  @override
  Color? get inactiveTrackColor => _colors.primary.withValues(alpha: 0.24);

  @override
  Color? get activeTrackMarkColor => _colors.onPrimary.withValues(alpha: 0.38);

  @override
  Color? get inactiveTrackMarkColor =>
      _colors.onSurfaceVariant.withValues(alpha: 0.38);

  @override
  SideSwapSliderTrackShape? get trackShape => SideSwapDefaultSliderTrackShape(
    leftGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        SideSwapColors.bitterSweet,
        _colors.primary.withValues(alpha: 0.24).withValues(alpha: .1),
      ],
    ),
    rightGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        _colors.primary.withValues(alpha: 0.24).withValues(alpha: .1),
        SideSwapColors.turquoise,
      ],
    ),
  );

  @override
  SideSwapSliderTrackMarkShape? get trackMarkShape =>
      SideSwapDefaultSliderTrackMarkShape();

  @override
  SideSwapSliderAxisInteraction? get axisInteraction =>
      SideSwapSliderAxisInteraction.left;

  @override
  SideSwapSliderComponentShape? get thumbShape =>
      SideSwapDefaultSliderThumbShape(
        thumbColor: Colors.blue[900],
        frameColor: Colors.lightBlueAccent,
        leftColor: SideSwapColors.bitterSweet,
        rightColor: SideSwapColors.turquoise,
      );

  @override
  SideSwapSliderHatchMarkShape? get hatchMarkShape =>
      SideSwapDefaultSliderHatchMarkShape(
        density: 0.1,
        padding: 4,
        markWidth: 1.0,
        markHeight: 10.0,
      );
}

class SideSwapSliderRenderObjectWidget extends LeafRenderObjectWidget {
  const SideSwapSliderRenderObjectWidget({
    super.key,
    this.focusNode,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.marks,
    this.hatchMarkLabels,
    required this.themeData,
    required this.state,
  }) : assert(
         value >= min && value <= max,
         'value must be between min and max. value: $value, min: $min, max: $max',
       );

  final FocusNode? focusNode;
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final List<SideSwapSliderTrackMark>? marks;
  final List<SideSwapSliderHatchMarkLabel>? hatchMarkLabels;
  final SideSwapSliderThemeData themeData;
  final SideSwapSliderState state;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSideSwapSlider(
      focusNode: focusNode,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      marks: marks ?? [],
      hatchMarkLabels: hatchMarkLabels ?? [],
      themeData: themeData,
      state: state,
      textDirection: Directionality.of(context),
      textStyle: DefaultTextStyle.of(context).style,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSideSwapSlider renderObject,
  ) {
    renderObject
      ..value = value
      ..onChanged = onChanged
      ..min = min
      ..max = max
      ..marks = marks ?? []
      ..hatchMarkLabels = hatchMarkLabels ?? []
      ..themeData = themeData
      ..textDirection = Directionality.of(context)
      ..textStyle = DefaultTextStyle.of(context).style;
  }
}

class RenderSideSwapSlider extends RenderBox {
  RenderSideSwapSlider({
    FocusNode? focusNode,
    required double value,
    required ValueChanged<double> onChanged,
    required double min,
    required double max,
    required SideSwapSliderThemeData themeData,
    required List<SideSwapSliderTrackMark> marks,
    required List<SideSwapSliderHatchMarkLabel> hatchMarkLabels,
    required SideSwapSliderState state,
    required TextDirection textDirection,
    required TextStyle textStyle,
  }) {
    _value = value;
    _onChanged = onChanged;
    _min = min;
    _max = max;
    _marks = marks;
    _hatchMarkLabels = hatchMarkLabels;
    _themeData = themeData;
    _state = state;
    _textDirection = textDirection;
    _textStyle = textStyle;

    _focusNode = focusNode;

    final team = GestureArenaTeam();
    _drag = HorizontalDragGestureRecognizer()
      ..team = team
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _endInteraction;
    _tap = TapGestureRecognizer()
      ..team = team
      ..onTapDown = _handleTapDown
      ..onTapUp = _handleTapUp
      ..onTapCancel = _endInteraction;
  }

  FocusNode? _focusNode;

  late double _value;
  late ValueChanged<double> _onChanged;
  late double _min;
  late double _max;
  late List<SideSwapSliderTrackMark>? _marks;
  late List<SideSwapSliderHatchMarkLabel>? _hatchMarkLabels;
  late SideSwapSliderThemeData _themeData;
  late SideSwapSliderState _state;
  late TextDirection _textDirection;
  late TextStyle _textStyle;

  late final HorizontalDragGestureRecognizer _drag;
  late final TapGestureRecognizer _tap;

  static const double _minPreferredTrackWidth = 144.0;

  double _currentDragValue = 0.0;

  set value(double value) {
    if (_value != value) {
      _value = value;
      markNeedsLayout();
    }
  }

  ValueChanged<double> get onChanged => _onChanged;

  set onChanged(ValueChanged<double> value) {
    if (_onChanged == value) {
      return;
    }

    _onChanged = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  set min(double value) {
    if (_min == value) {
      return;
    }

    _min = value;
    markNeedsLayout();
  }

  set max(double value) {
    if (_max == value) {
      return;
    }

    _max = value;
    markNeedsLayout();
  }

  set marks(List<SideSwapSliderTrackMark>? value) {
    if (_marks == value) {
      return;
    }

    _marks = value;
    markNeedsLayout();
  }

  set hatchMarkLabels(List<SideSwapSliderHatchMarkLabel>? value) {
    if (_hatchMarkLabels == value) {
      return;
    }

    _hatchMarkLabels = value;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  set themeData(SideSwapSliderThemeData value) {
    if (_themeData == value) {
      return;
    }

    _themeData = value;
    markNeedsLayout();
  }

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  set textStyle(TextStyle value) {
    if (_textStyle == value) {
      return;
    }

    _textStyle = value;
    markNeedsLayout();
  }

  void _handleTapUp(TapUpDetails details) {
    _endInteraction();
  }

  void _handleDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _handleDragStart(DragStartDetails details) {
    _startInteraction(details.globalPosition);
  }

  void _endInteraction() {
    if (!_state.mounted) {
      return;
    }

    if (_state.mounted) {
      _currentDragValue = 0.0;
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(_themeData.trackShape != null);

    if (!_state.mounted || details.primaryDelta == null) {
      return;
    }

    final trackRect = _themeData.trackShape!.getPrefferedRect(
      parentBox: this,
      offset: Offset.zero,
      themeData: _themeData,
    );

    final double valueDelta = details.primaryDelta! / trackRect.width;
    _currentDragValue += valueDelta;

    onChanged.call(clampDouble(_currentDragValue, 0.0, 1.0));
  }

  void _handleTapDown(TapDownDetails details) {
    _startInteraction(details.globalPosition);
  }

  void _startInteraction(Offset globalPosition) {
    _focusNode?.requestFocus();
    _currentDragValue = _getValueFromGlobalPosition(globalPosition);
    onChanged.call(clampDouble(_currentDragValue, 0.0, 1.0));
  }

  double _getValueFromGlobalPosition(Offset globalPosition) {
    final trackRect = _themeData.trackShape!.getPrefferedRect(
      parentBox: this,
      offset: Offset.zero,
      themeData: _themeData,
    );

    final visualPosition =
        (globalToLocal(globalPosition).dx - trackRect.left) / trackRect.width;

    return clampDouble(visualPosition, 0.0, 1.0);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      // We need to add the drag first so that it has priority.
      _drag.addPointer(event);
      _tap.addPointer(event);
    }
  }

  @override
  bool get sizedByParent => true;

  Size _layoutText(double maxWidth) {
    var longestLineWidth = .0;
    var textHeight = .0;

    for (final label in _hatchMarkLabels!) {
      if (label.label.isEmpty) {
        continue;
      }

      final textPainter = TextPainter(
        text: TextSpan(text: label.label, style: label.style),
        textDirection: _textDirection,
      );
      textPainter.layout(maxWidth: maxWidth);
      textHeight = math.max(textHeight, textPainter.height);

      final textLines = textPainter.computeLineMetrics();
      for (final line in textLines) {
        longestLineWidth = math.max(longestLineWidth, line.width);
      }
    }

    return Size(longestLineWidth, textHeight);
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    assert(_themeData.thumbShape != null);

    final thumbRect = _themeData.thumbShape!.getPrefferedSize();
    var hatchMarkHeight =
        _themeData.hatchMarkShape?.markHeight ??
        .0 + (_themeData.hatchMarkShape?.padding ?? .0);

    if (_hatchMarkLabels?.isNotEmpty == true) {
      for (final label in _hatchMarkLabels!) {
        hatchMarkHeight = math.max(hatchMarkHeight, label.markHeight ?? 0);
      }
    }

    final maxWidth = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : _minPreferredTrackWidth;

    final textSize = _layoutText(maxWidth);

    final maxHeight = constraints.hasBoundedHeight
        ? constraints.maxHeight
        : math.max(_themeData.trackHeight!, thumbRect.height) +
              hatchMarkHeight +
              (_themeData.hatchMarkShape?.padding ?? .0) +
              textSize.height;

    return Size(math.max(maxWidth, textSize.width), maxHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(_themeData.trackHeight != null);
    assert(_themeData.trackShape != null);

    final canvas = context.canvas;
    canvas.save();

    final padding = _themeData.trackHeight!;

    final trackRect = _themeData.trackShape!.getPrefferedRect(
      parentBox: this,
      offset: offset,
      themeData: _themeData,
    );
    final thumbCenter = Offset(
      offset.dx + padding + (trackRect.width * (_value - _min) / (_max - _min)),
      trackRect.center.dy,
    );

    /// draw track
    _themeData.trackShape?.paint(
      context,
      offset,
      parentBox: this,
      thumbCenter: thumbCenter,
      themeData: _themeData,
    );

    // draw track marks
    _themeData.trackMarkShape?.paint(
      context,
      offset,
      parentBox: this,
      thumbCenter: thumbCenter,
      themeData: _themeData,
      marks: _marks ?? [],
      min: _min,
      max: _max,
    );

    // draw thumb
    _themeData.thumbShape?.paint(
      context,
      offset,
      thumbCenter,
      parentBox: this,
      themeData: _themeData,
    );

    // draw hatch marks
    _themeData.hatchMarkShape?.paint(
      context,
      offset,
      parentBox: this,
      thumbCenter: thumbCenter,
      themeData: _themeData,
      labels: _hatchMarkLabels ?? [],
      defaultTextDirection: _textDirection,
      defaultTextStyle: _textStyle,
      min: _min,
      max: _max,
    );

    canvas.restore();
  }
}
