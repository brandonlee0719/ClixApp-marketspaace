import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/dialogueServices/dialogueService.dart';

final inter1 = GoogleFonts.inter(
  color: AppColors.text_field_color,
  fontWeight: FontWeight.w400,
  fontSize: SizeConfig.textMultiplier * 0.757532281205165,
  letterSpacing: 0.25,
);

final inter2 = GoogleFonts.inter(
  color: AppColors.text_field_color,
  fontWeight: FontWeight.w400,
  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
  letterSpacing: 0.25,
);

class ConvertCard extends StatefulWidget {
  @override
  _ConvertCardState createState() => _ConvertCardState();
}

class _ConvertCardState extends State<ConvertCard> {
  String sourceCurrency = 'BTC';
  String destCurrency = 'ETH';

  Map<String, String> assetMap = {
    "BTC": 'assets/images/logos_bitcoin.png',
    "ETH": 'assets/images/ethereum_logo.png',
    "USDC": 'assets/images/cryptocurrency_usdc.png',
    "AUD": 'assets/images/aus_flag.png',
  };

  Future<void> readConvertDialogue() async {
    var result = await DialogueService.instance.showConvertDialogue(context);
    // print(result);
    if (result != null) {
      setState(() {
        sourceCurrency = result[0];
        destCurrency = result[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: readConvertDialogue,
      child: Card(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 4,
            right: SizeConfig.widthMultiplier * 4),
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
            child: Row(
              children: [
                IconBox(
                  assetImage: assetMap[sourceCurrency],
                ),
                TextArea(
                  top: "From",
                  bot: sourceCurrency,
                ),
                SizedBox(
                  width: SizeConfig.widthMultiplier * 22,
                ),
                RotationTransition(
                    turns: new AlwaysStoppedAnimation(90 / 360),
                    child:
                        IconBox(assetImage: "assets/images/suffel_icon.png")),
                SizedBox(
                  width: SizeConfig.widthMultiplier * 22,
                ),
                TextArea(
                  top: "To",
                  bot: destCurrency,
                ),
                IconBox(
                  assetImage: assetMap[destCurrency],
                ),
              ],
            )),
      ),
    );
  }
}

class TextArea extends StatelessWidget {
  final String bot;
  final String top;

  const TextArea({Key key, this.bot, this.top});

  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.widthMultiplier * 10,
      child: Column(
        children: [
          Text(
            top,
            style: inter2,
          ),
          Text(
            bot,
            style: inter2,
          ),
        ],
      ),
    );
  }
}

class IconBox extends StatelessWidget {
  final String assetImage;
  final double size;

  const IconBox({Key key, this.assetImage, this.size = 6.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: SizeConfig.widthMultiplier * size,
        height: SizeConfig.widthMultiplier * size,
        child: Image.asset(assetImage));
  }
}
