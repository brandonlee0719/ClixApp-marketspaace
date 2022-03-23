import 'package:flutter/cupertino.dart';

class  CenterContainer extends StatelessWidget {
  final Widget child;

  const CenterContainer({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: child,
      ),
    );
  }
}
