import 'package:flutter/cupertino.dart';
import 'package:market_space/common/commonWidgets/centerContainer.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/responsive_layout/size_config.dart';



class TransactionWidget extends StatelessWidget {
  final String name;
  final String blueText;
  final String greyText;

  const TransactionWidget({Key key, this.name, this.blueText, this.greyText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(

      children: [
        SizedBox(
          height: SizeConfig.heightMultiplier*10,
        ),
        CenterContainer(child: Image.asset(name,
        width: SizeConfig.widthMultiplier*69,),),
        SizedBox(
          height: SizeConfig.heightMultiplier*1.5,
        ),
        CenterContainer(child: Text(blueText),),
        SizedBox(
          height: SizeConfig.heightMultiplier*1.5,
        ),
        CenterContainer(child: Text(greyText),),
        SizedBox(
          height: SizeConfig.heightMultiplier*8,
        ),
        ButtonBuilder().build(ButtonSection(ButtonSectionType.confirmButton, "return to home",
            (){Navigator.pop(context);}))
      ],
    );
  }
}
