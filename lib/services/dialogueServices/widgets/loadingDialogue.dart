part of '../dialogueService.dart';

class _LoadingDialogue extends StatefulWidget {
  final Function futureFunction;

  const _LoadingDialogue({Key key, this.futureFunction}) : super(key: key);
  @override
  __LoadingDialogueState createState() => __LoadingDialogueState();
}

class __LoadingDialogueState extends State<_LoadingDialogue> {
  @override
  void initState() {
    trigger();

    // TODO: implement initState
    super.initState();
  }

  Future<void> trigger() async {
    try {
      await widget.futureFunction();
    } catch (e) {
      // print(e);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Loading'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Please wait for the order data to load'),
          ],
        ),
      ),
    );
  }
}
