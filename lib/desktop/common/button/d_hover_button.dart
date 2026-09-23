import 'package:flutter/material.dart';

class DHoverButton extends StatefulWidget {
  const DHoverButton({
    super.key,
    this.cursor,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onPressed,
    this.onTapUp,
    this.onTapDown,
    this.onTapCancel,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    required this.builder,
    this.focusNode,
    this.margin,
    this.semanticLabel,
    this.autofocus = false,
    this.onFocusChange,
  });

  final MouseCursor? cursor;
  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;

  final VoidCallback? onPressed;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapCancel;

  final GestureDragStartCallback? onHorizontalDragStart;
  final GestureDragUpdateCallback? onHorizontalDragUpdate;
  final GestureDragEndCallback? onHorizontalDragEnd;

  final ButtonStateWidgetBuilder builder;

  final FocusNode? focusNode;

  final EdgeInsetsGeometry? margin;

  final String? semanticLabel;

  final bool autofocus;

  final ValueChanged<bool>? onFocusChange;

  @override
  State<DHoverButton> createState() => DHoverButtonState();
}

class DHoverButtonState extends State<DHoverButton> {
  /// The node this state created, and the only node it may ever dispose. A
  /// caller's node is never assigned here, so no disposal path can reach it.
  FocusNode? _internalNode;

  /// The node currently in effect, resolved on every read so that a node
  /// supplied after mount is adopted rather than ignored.
  FocusNode get node =>
      widget.focusNode ?? (_internalNode ??= _createFocusNode());

  late Map<Type, Action<Intent>> _actionMap;

  @override
  void initState() {
    super.initState();
    void handleActionTap() async {
      if (!enabled) return;
      setState(() => _pressing = true);
      widget.onPressed?.call();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (mounted) setState(() => _pressing = false);
    }

    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => handleActionTap(),
      ),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
        onInvoke: (ButtonActivateIntent intent) => handleActionTap(),
      ),
    };
  }

  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }

  bool _hovering = false;
  bool _pressing = false;
  bool _shouldShowFocus = false;

  bool get enabled =>
      widget.onPressed != null ||
      widget.onTapUp != null ||
      widget.onTapDown != null ||
      widget.onTapDown != null ||
      widget.onLongPress != null ||
      widget.onLongPressStart != null ||
      widget.onLongPressEnd != null;

  Set<ButtonStates> get states {
    if (!enabled) return {ButtonStates.disabled};
    return {
      if (_pressing) ButtonStates.pressing,
      if (_hovering) ButtonStates.hovering,
      if (_shouldShowFocus) ButtonStates.focused,
    };
  }

  @override
  void didUpdateWidget(DHoverButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode == oldWidget.focusNode) return;
    // The focus highlight is cached here but reported by the
    // `FocusableActionDetector` the node change is about to discard, and a
    // detaching focus node notifies nobody on its way out — so left alone this
    // flag would go on describing a node the button no longer answers for.
    //
    // Only this flag. `_hovering` is re-reported by the replacement
    // `MouseRegion` in both directions, so clearing it here would only blank the
    // hover highlight for the swap frame; `_pressing` belongs to the gesture
    // layer, which sits outside the key and survives the swap, so clearing it
    // would release a press whose pointer is still down.
    setState(() => _shouldShowFocus = false);
  }

  @override
  void dispose() {
    _internalNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget w = FocusableActionDetector(
      // Keyed on the node so that swapping it rebuilds the detector's state:
      // `FocusableActionDetector` gates focus reporting on a cached `_focused`
      // that survives a node swap, so a reused state would stay convinced it is
      // focused and never report focus through the adopted node again. The key
      // never changes for a button whose node is stable.
      //
      // The gesture layer is deliberately kept *outside* this key: rebuilding
      // the detector tears down everything beneath it, and a gesture layer torn
      // down mid-gesture drops the recognizers' pointer routes — swallowing a
      // tap in flight and leaving a long press with no end event.
      key: ValueKey(node),
      mouseCursor: widget.cursor ?? MouseCursor.defer,
      focusNode: node,
      autofocus: widget.autofocus,
      enabled: enabled,
      actions: _actionMap,
      onFocusChange: widget.onFocusChange,
      onShowFocusHighlight: (v) {
        if (mounted) setState(() => _shouldShowFocus = v);
      },
      onShowHoverHighlight: (v) {
        if (mounted) setState(() => _hovering = v);
      },
      child: widget.builder(context, states),
    );
    w = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onPressed,
      onTapDown: (_) {
        if (mounted) setState(() => _pressing = true);
        widget.onTapDown?.call();
      },
      onTapUp: (_) async {
        widget.onTapUp?.call();
        if (!enabled) return;
        await Future<void>.delayed(const Duration(milliseconds: 100));
        if (mounted) setState(() => _pressing = false);
      },
      onTapCancel: () {
        widget.onTapCancel?.call();
        if (mounted) setState(() => _pressing = false);
      },
      onLongPress: widget.onLongPress,
      onLongPressStart: (_) {
        widget.onLongPressStart?.call();
        if (mounted) setState(() => _pressing = true);
      },
      onLongPressEnd: (_) {
        widget.onLongPressEnd?.call();
        if (mounted) setState(() => _pressing = false);
      },
      onHorizontalDragStart: widget.onHorizontalDragStart,
      onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
      onHorizontalDragEnd: widget.onHorizontalDragEnd,
      child: w,
    );
    w = MergeSemantics(
      child: Semantics(
        label: widget.semanticLabel,
        button: true,
        enabled: enabled,
        focusable: enabled,
        focused: node.hasFocus,
        child: w,
      ),
    );
    if (widget.margin != null) w = Padding(padding: widget.margin!, child: w);
    return w;
  }
}

enum ButtonStates { disabled, hovering, pressing, focused, none }

typedef ButtonStateWidgetBuilder =
    Widget Function(BuildContext context, Set<ButtonStates> states);

typedef ButtonStateResolver<T> = T Function(Set<ButtonStates> states);

abstract class ButtonState<T> {
  T resolve(Set<ButtonStates> states);

  static ButtonState<T> all<T>(T value) => _AllButtonState(value);

  static ButtonState<T> resolveWith<T>(ButtonStateResolver<T> callback) {
    return _ButtonState(callback);
  }

  static ButtonState<T?>? lerp<T>(
    ButtonState<T?>? a,
    ButtonState<T?>? b,
    double t,
    T? Function(T?, T?, double) lerpFunction,
  ) {
    if (a == null && b == null) return null;
    return _LerpProperties<T>(a, b, t, lerpFunction);
  }
}

class _ButtonState<T> extends ButtonState<T> {
  _ButtonState(this._resolve);

  final ButtonStateResolver<T> _resolve;

  @override
  T resolve(Set<ButtonStates> states) => _resolve(states);
}

class _AllButtonState<T> extends ButtonState<T> {
  _AllButtonState(this._value);

  final T _value;

  @override
  T resolve(states) => _value;
}

class _LerpProperties<T> implements ButtonState<T?> {
  const _LerpProperties(this.a, this.b, this.t, this.lerpFunction);

  final ButtonState<T?>? a;
  final ButtonState<T?>? b;
  final double t;
  final T? Function(T?, T?, double) lerpFunction;

  @override
  T? resolve(Set<ButtonStates> states) {
    final T? resolvedA = a?.resolve(states);
    final T? resolvedB = b?.resolve(states);
    return lerpFunction(resolvedA, resolvedB, t);
  }
}

extension ButtonStatesExtension on Set<ButtonStates> {
  bool get isFocused => contains(ButtonStates.focused);
  bool get isDisabled => contains(ButtonStates.disabled);
  bool get isPressing => contains(ButtonStates.pressing);
  bool get isHovering => contains(ButtonStates.hovering);
  bool get isNone => isEmpty;
}
