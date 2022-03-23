import 'package:flutter/cupertino.dart';

class ExpandableWidget extends StatefulWidget {
  final Widget widget1;
  final Widget widget2;

  const ExpandableWidget({Key key, this.widget1, this.widget2}) : super(key: key);
  @override
  _ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  bool isToggle = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          isToggle = !isToggle;
        });
      },
      child: Column(
          children: <Widget>[
            widget.widget1,
            if (isToggle)
              widget.widget2
          ]
      ),
    );
  }
}
