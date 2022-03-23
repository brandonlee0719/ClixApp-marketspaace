import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/notification/models/commonQuestionModel.dart';
import 'package:market_space/notification/representation/widgets/ExpandableWidget.dart';
import 'package:market_space/providers/algoliaCLient.dart';
import 'package:market_space/representation/commons/reusanleFonts.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionModel model;

  const QuestionWidget({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandableWidget(
        widget1:TextContainer(child:Text(model.question,
            style: GoogleFonts.inter(
              color: Color.fromRGBO(33, 33, 33, 1),
              fontWeight:FontWeight.w700,
              fontSize: SizeConfig.textMultiplier*2.5
            ),

        )),
        widget2: TextContainer(child:Text(model.answer)),

      ),
        Divider(
          height: 0,
          color: Colors.grey,
          endIndent: SizeConfig.widthMultiplier*3,
          indent: SizeConfig.widthMultiplier*3,
        )
      ]
    );
  }

}

class TextContainer extends StatelessWidget {
  final Widget child;

  const TextContainer({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(SizeConfig.widthMultiplier*3),
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 0),
              child: child
          )

      ),
        Divider(
          height: 0,
          color: AppColors.list_separator,
          endIndent: SizeConfig.widthMultiplier*3,
          indent: SizeConfig.widthMultiplier*3,
        )

    ]
    );
  }
}

class HelpModel{
  final String title;
  final Function onClick;
  HelpModel(this.title,{this.onClick});


}


class HelpTile extends StatelessWidget {
  final HelpModel model;

  const HelpTile({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        SizedBox(
          height: SizeConfig.heightMultiplier*2.75,
        ),
        Row(
          children:[
            TextContainer(
              child: Text(model.title,
                  style: GoogleFonts.inter(
                      color: AppColors.gray_500,
                      fontSize: SizeConfig.textMultiplier * 2.5086083213773316,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier*0.2,
                left: SizeConfig.widthMultiplier *
                1.9444444444444442),
              child: Image.asset(
                'assets/images/chevron_right.png',
              height: SizeConfig.heightMultiplier *
                1.0043041606886658,
              width: SizeConfig.widthMultiplier *
                1.2152777777777777,
            ),
            ),


          ]
        ),
        Divider(
          height: 0,
          color: AppColors.list_separator,
          endIndent: SizeConfig.widthMultiplier*3,
          indent: SizeConfig.widthMultiplier*3,
        )
      ]
    );
  }
}




class StaticTileFactory{
  static StaticTileFactory instance = StaticTileFactory();

  Widget build(dynamic model){
    switch(model.runtimeType.toString()){
      case("QuestionModel"):

        return QuestionWidget(
          model: model,
        );
      case("HelpModel"):
        if(model.onClick!=null){
          return GestureDetector(
            onTap: model.onClick,
            child: HelpTile(model: model,),
          );
        }
        return HelpTile(model: model,);
      default:
        return Container(
          color: AppColors.appBlue,
        );
    }

  }
}