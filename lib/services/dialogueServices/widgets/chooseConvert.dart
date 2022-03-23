part of '../dialogueService.dart';

class ChooseConvertDialogue extends StatefulWidget {
  @override
  _ChooseConvertDialogueState createState() => _ChooseConvertDialogueState();
}

class _ChooseConvertDialogueState extends State<ChooseConvertDialogue> {
  List<String> sourceCurrencyList = ["USDC","BTC", "AUD"];
  List<String> destCurrencyList = ["USDC", "ETH", "AUD"];
  String valueOne = "BTC";
  String valueTwo = "ETH";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        titlePadding: EdgeInsets.zero,
        content: Container(
          height: SizeConfig.heightMultiplier*25,
          child: Column(

            children: [
              dropdownValue(valueOne, sourceCurrencyList,1),
              dropdownValue(valueTwo, destCurrencyList,2),
              Center(

                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context, [valueOne,valueTwo]);

                  },
                  padding: EdgeInsets.zero,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradient_button_light,
                          AppColors.gradient_button_dark
                        ],
                      ),
                    ),
                    child: Text(
                      'FINALISE ORDER',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          color: AppColors.white),
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
   );
  }

  Widget dropdownValue(String dropdownValue, List<String> dropdownList, int id){
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          if(newValue!=null){
            if(id == 1){
              destCurrencyList.add(valueOne);
              valueOne = newValue;
              destCurrencyList.remove(valueOne);
              if(valueOne == valueTwo){
                valueTwo = destCurrencyList[0];
              }
            }
            else{
              sourceCurrencyList.add(valueTwo);
              valueTwo = newValue;
              sourceCurrencyList.remove(valueTwo);
              if(valueOne == valueTwo){
                valueOne = sourceCurrencyList[0];
            }

          }
        }});
      },
      items: dropdownList
          .map<DropdownMenuItem<String>>((String value) {

        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
