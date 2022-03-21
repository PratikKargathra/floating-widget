import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FloatingWidget extends StatefulWidget {

  Widget child;
  bool rotate = true;
  bool scaleUpDown = true;

  FloatingWidget({Key? key, required this.child, this.rotate=true, this.scaleUpDown = true}) : super(key: key);

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}
class _FloatingWidgetState extends State<FloatingWidget> {

  Offset offset = Offset.zero;
  double initialScale = 1.0;
  double scaleFactor = 1.0;
  double rotation = 0.0;
  double iRotation = 0.0;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return  Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onScaleStart: (_) {
          setState(() {
            pressed = true;
            initialScale = scaleFactor;
            iRotation = rotation;
          });
        },
        onScaleUpdate: (details){
          setState(() {
            offset += details.focalPointDelta;
            scaleFactor = initialScale * details.scale;
            rotation = iRotation+details.rotation;
          });
        },

        onScaleEnd: (_){
          setState(() {
            pressed = false;
          });
        },
        child: Container(
          padding: EdgeInsets.all((widget.scaleUpDown)?50*scaleFactor:50),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.black.withOpacity((pressed)?0.20:0.0)),
          ),
          child: Transform.rotate(
            alignment: FractionalOffset.center,
            angle: (widget.rotate)?rotation:0,
            child: Transform.scale(
              alignment: FractionalOffset.center,
              scale: (widget.scaleUpDown)?scaleFactor:1,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}