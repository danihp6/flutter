import 'package:flutter/material.dart';

import 'utils.dart';

class FittedTextFieldContainer extends StatefulWidget {
  /// Creates a container to wrap a [child] `TextField`  and automatically resizes to fit the [child]'s text value
  ///
  /// ```dart
  /// FittedTextFieldContainer(
  ///   child: TextField(...),
  /// )
  /// ```

  /// The `TextField` to wrap
  final TextField child;

  /// The width of the `TextField.decoration.prefixIcon` if used
  final double prefixIconWidth;

  /// The width of the `TextField.decoration.suffixIcon` if used
  final double suffixIconWidth;

  /// The minimum width, default is 0 - which makes the TextField invisible if the TextField
  /// doesn't include properties that takes up space (such as labelText, prefixIcon, etc).
  final double minWidth;

  /// The maximum width, defaults to `double.infinity` - i.e. there is no maximum
  final double maxWidth;

  const FittedTextFieldContainer({
    Key key,
    @required this.child,
    this.prefixIconWidth = 48,
    this.suffixIconWidth = 48,
    this.minWidth = 0,
    this.maxWidth = double.infinity,
  })  : assert(child != null),
        super(key: key);

  @override
  FittedTextFieldContainerState createState() =>
      FittedTextFieldContainerState();
}

class FittedTextFieldContainerState extends State<FittedTextFieldContainer> {
  double _prefixWidth;
  double _suffixWidth;
  double _hintWidth;
  double _labelWidth;
  double _fixedWidth;
  double _textFieldWidth;
  TextStyle _defaultTextStyle;

  @override
  void initState() {
    assert(widget.child.controller != null);
    widget.child.controller.addListener(resize);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // When style is null, it defaults to `subtitle1` of current field.
    // See: https://api.flutter.dev/flutter/material/TextField/style.html
    _defaultTextStyle =
        widget.child.style ?? Theme.of(context).textTheme.subhead;

    _prefixWidth = getPrefixTextSize(widget.child, _defaultTextStyle).width;
    _suffixWidth = getSuffixTextSize(widget.child, _defaultTextStyle).width;
    _hintWidth = getHintTextSize(widget.child, _defaultTextStyle).width;
    _labelWidth = getLabelTextSize(widget.child, _defaultTextStyle).width;
    _fixedWidth = _prefixWidth + _suffixWidth;

    if (widget.child.decoration.prefixIcon != null) {
      _fixedWidth += widget.prefixIconWidth;
    }
    if (widget.child.decoration.suffixIcon != null) {
      _fixedWidth += widget.suffixIconWidth;
    }

    // Add enough space for the cursor to prevent it being positined onto the next line
    // in a multiline textfield and scrolled in a single-line text field.
    _fixedWidth += widget.child.cursorWidth + 1;
    _textFieldWidth = _geTextFieldWidth();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.child.controller.removeListener(resize);
    super.dispose();
  }

  double _geTextFieldWidth() {
    double textWidth = getTextSize(widget.child, _defaultTextStyle).width;
    double width = textWidth > _hintWidth ? textWidth : _hintWidth;
    if (_labelWidth > width) {
      width = _labelWidth;
    }
    width += _fixedWidth;

    if (widget.child.decoration.prefixIcon != null) {
      width += widget.prefixIconWidth;
    }
    if (widget.child.decoration.suffixIcon != null) {
      width += widget.suffixIconWidth;
    }

    if (width < widget.minWidth) {
      width = widget.minWidth;
    }
    if (width > widget.maxWidth) {
      width = widget.maxWidth;
    }
    return width + 10;
  }

  void resize() {
    final width = _geTextFieldWidth();
    if (width != _textFieldWidth) {
      setState(() {
        _textFieldWidth = width;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _textFieldWidth,
      child: widget.child,
    );
  }
}
