part of 'message_widgets.dart';

class _ProductWidget extends StatefulWidget {
  final String message;


  const _ProductWidget({Key key, this.message}) : super(key: key);
  @override
  __ProductWidgetState createState() => __ProductWidgetState();
}

class __ProductWidgetState extends State<_ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(widget.message),
    );
  }
}
