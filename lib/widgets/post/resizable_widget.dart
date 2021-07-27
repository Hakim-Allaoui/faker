import 'package:faker/utils/tools.dart';
import 'package:flutter/material.dart';

class ResizableWidget extends StatefulWidget {
  final double height;
  final double maxHeight;
  final double dividerHeight;
  final double dividerSpace;
  final Widget child;
  final Function(bool) onTap;
  final Function(double) onRelease;

  const ResizableWidget({
    Key key,
    @required this.child,
    this.height = 300,
    this.maxHeight = 600,
    this.dividerHeight = 40,
    this.dividerSpace = 2, this.onTap,this.onRelease,
  }) : super(key: key);

  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget> {
  double _height, _maxHeight, _dividerHeight, _dividerSpace, _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _height = widget.height;
    _maxHeight = widget.maxHeight;
    _dividerHeight = widget.dividerHeight;
    _dividerSpace = widget.dividerSpace;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      overflow: Overflow.visible,
      children: <Widget>[
        GestureDetector(
          child: Container(
            height: _height,
            width: Tools.width,
            child: widget.child,
          ),
          onPanDown: (d) {
            widget.onTap(true);
          },
          onPanUpdate: (details) {
            setState(() {
              _opacity = 0.8;
              _height += details.delta.dy;
              var maxLimit = _maxHeight - _dividerHeight - _dividerSpace;
              var minLimit = 44.0;
              if (_height > maxLimit)
                _height = maxLimit;
              else if (_height < minLimit) _height = minLimit;
            });
          },
          onPanEnd: (details) {
            widget.onRelease(_height);
            widget.onTap(false);
            setState(() {
              _opacity = 0.0;
            });
          },
        ),
        Positioned(
          bottom: -10.0,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: _opacity,
            child: Container(
              height: _dividerHeight,
              width: Tools.width,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
            ),
          ),
        )
      ],
    );
  }
}
