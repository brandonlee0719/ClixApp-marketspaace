import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  MultiSelectChip(this.reportList);

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  // List<String> selectedChoices = List();
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(
            item,
            style: GoogleFonts.inter(
                color: Constants.selectedChoices.contains(item)
                    ? AppColors.white
                    : AppColors.black),
          ),
          selectedColor: AppColors.toolbarBlue,
          selected: Constants.selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              Constants.selectedChoices.contains(item)
                  ? Constants.selectedChoices.remove(item)
                  : Constants.selectedChoices.add(item);
              // print('selected: ${selected}');
              // print(Constants.selectedChoices);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
