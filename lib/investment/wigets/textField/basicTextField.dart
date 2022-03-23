import 'package:flutter/cupertino.dart';
import 'package:market_space/investment/constants/gFonts.dart';
import 'package:market_space/investment/logic/investment_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class BasicText extends StatefulWidget {
  final String labelText;
  final TextStyle style;
  final TextAlign align;
  final bool isTop;

  const BasicText({Key key, this.labelText, this.style, this.align, this.isTop})
      : super(key: key);

  @override
  _BasicTextState createState() => _BasicTextState();
}

class _BasicTextState extends State<BasicText> {
  @override
  Widget build(BuildContext context) {
    if (this.widget.align != null) {
      return Container(
          child: Text(
        widget.labelText,
        style: widget.style,
        textAlign: widget.align,
      ));
    }
    if (widget.isTop != null && widget.isTop == true) {
      return Container(
          child: Text(
        widget.labelText,
        style: widget.style,
      ));
    }
    return Container(
        margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 5),
        child: Text(
          widget.labelText,
          style: widget.style,
        ));
  }
}

//to-do: this class should extend from the basic text class!
//to-do: add the unfinished feature to thr Response text.

class ResponseText extends StatefulWidget {
  final String labelText;
  final TextStyle style;
  final TextAlign align;
  final EdgeInsets insets;
  final double amount;

  const ResponseText(
      {Key key,
      this.labelText,
      this.style,
      this.align,
      this.amount,
      this.insets})
      : super(key: key);

  @override
  _ResponseTextState createState() => _ResponseTextState();
}

class _ResponseTextState extends State<ResponseText> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: widget.insets,
        child: Builder(builder: (context) {
          final state = context.watch<InvestmentBloc>().state;
          final wallet =
              context.watch<InvestmentBloc>().walletRepository.wallet;
          if (state == InvestmentState.reloadSuccess) {
            // print(widget.labelText);
            // print(wallet.disPlayMap[widget.labelText]);

            return Text(
              wallet.disPlayMap[widget.labelText],
              style: widget.style,
            );
          } else if (state == InvestmentState.reloadFail) {
            return Text(
              "error",
              style: widget.style,
            );
          }
          //give a default value here
          return Text(
            'loading....',
            style: widget.style,
          );
        }));
  }
}
