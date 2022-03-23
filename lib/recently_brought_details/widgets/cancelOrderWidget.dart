import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/orderApi/orderApi.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/dropdownField.dart';
import 'package:market_space/core/widgets/buttons/custom_buttons.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';

import '../recenlty_bought_l10n.dart';

enum status {
  initial,
  awaitingBuyerAccept,
  awaitingSellerAccept,
  awaitingMeditation,
  accepted,
}

class CancelOrderWidget extends StatefulWidget {
  final isExtension;
  final bool isBuyer;

  const CancelOrderWidget(
      {Key key, this.isExtension = false, this.isBuyer = false})
      : super(key: key);
  @override
  _CancelOrderWidgetState createState() => _CancelOrderWidgetState();
}

class _CancelOrderWidgetState extends State<CancelOrderWidget> {
  RecentlyBoughtL10n _l10n = RecentlyBoughtL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  final TextEditingController _reasonController = TextEditingController();
  String _selectedOption;
  List<String> _dropdownItems;
  String statusKey = "cancelStatus";
  String claimBy = "cancelBy";
  String available = "cancelAvailable";
  String claim = "cancel";

  Map<String, int> extensionMap = {
    "3 days": 3,
    "7 days": 7,
    "21 days": 21,
    "28 days": 28,
  };

  @override
  void initState() {
    if (widget.isExtension) {
      this.statusKey = "claimStatus";
      this.claimBy = "claimBy";
      this.available = "claimAvailable";
      this.claim = "claim";
    }
    _dropdownItems = widget.isBuyer
        ? [
            // '${_l10n.CancelOrder} *',
            _l10n.noLongerNeedItem,
            _l10n.MistakenlyPurchased,
            _l10n.Other
          ]
        : ['Item is out of stock', 'Buyer asked to cancel', 'Other'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: locator.get<OrderApi>().getClaimSnapShot(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            // print("DDATA: $data");
            //this is added to avoid assignment operation overriding the current state
            if (_selectedOption == null) {
              _selectedOption = widget.isExtension
                  ? (data['require days'] != null &&
                          extensionMap
                              .containsKey('${data['require days']} days'))
                      ? '${data['require days']} days'
                      : null
                  : (data['claimDetailedReason']?.isNotEmpty ?? false)
                      ? data['claimDetailedReason']
                      : null;
            }
            //this is added to avoid assignment operation overriding the current state
            if (_reasonController.text?.isEmpty ?? true) {
              _reasonController.text =
                  (data['claimReason']?.isNotEmpty ?? false)
                      ? !widget.isExtension
                          ? data['claimReason']
                          : null
                      : null;
            }

            return (data['extensionStatus'] == "IN MEDIATION" ||
                        data['extensionStatus'] == "CLAIM RAISED") &&
                    !widget.isExtension
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left:
                                SizeConfig.widthMultiplier * 3.8888888888888884,
                            right: 16,
                            top: 20,
                            bottom: 12),
                        child: Text(
                          widget.isExtension
                              ? 'Extend Order Protection'
                              : 'Cancel Order',
                          style: GoogleFonts.inter(
                            color: AppColors.app_txt_color,
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (data[statusKey] == "CLAIM RAISED")
                        if ((data[claimBy] == "buyer" && widget.isBuyer) ||
                            (data[claimBy] == "seller" && !widget.isBuyer))
                          _initialScreen(data[statusKey])
                        // _displayText(
                        //     "your $claim is already submitted, and is waiting for confirmation")
                        else
                          _accept()
                      else if (data[statusKey] == "COMPLETED")
                        _initialScreen(data[statusKey])
                      // else if (data[status] == "IN MEDIATION")
                      //   _displayText(
                      //       "the $claim is waiting for mediation, plz wait for more information")
                      else
                        _initialScreen(data[statusKey])
                    ],
                  );
          }
          return const SizedBox.shrink();
        });
  }

  Widget _displayText(String text) {
    return Container(
        width: SizeConfig.widthMultiplier * 80,
        height: SizeConfig.heightMultiplier * 10,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 10,
            right: SizeConfig.widthMultiplier * 10),
        child: Text(text));
  }

  void _acceptClaim() {
    locator.get<OrderApi>().acceptClaim(isExtension: widget.isExtension);
  }

  void _declineClaim() {
    locator.get<OrderApi>().declineClaim(isExtension: widget.isExtension);
  }

  Widget _accept() {
    return Container(
      width: SizeConfig.widthMultiplier * 100,
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            width: SizeConfig.widthMultiplier * 70,
            child: Text(
                "You have received a $claim, do you want to accept or decline it?\n",
                style: TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.center),
          ),
          ButtonBuilder().build(ButtonSection(
              ButtonSectionType.blueButton, "ACCEPT", _acceptClaim)),
          ButtonBuilder().build(ButtonSection(
              ButtonSectionType.redButton, "DECLINE", _declineClaim)),
        ],
      ),
    );
  }

  Widget _initialScreen(String cancellationStatus) {
    final canEditFields = cancellationStatus != "CLAIM RAISED" &&
        cancellationStatus != "COMPLETED";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: IgnorePointer(
              ignoring: !canEditFields,
              child: DropdownField<String>(
                borderColor: canEditFields
                    ? AppColors.text_field_container
                    : Colors.grey.shade300,
                dropdownItems: (_dropdownItems ?? [])
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ),
                    )
                    .toList(),
                textStyle: TextStyle(
                    color: canEditFields ? Colors.black : Colors.grey),
                hintText: !widget.isExtension
                    ? '${_l10n.CancelOrder} *'
                    : "Raise Claim *",
                value: _selectedOption,
                onChanged: (val) => setState(() => _selectedOption = val),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                scrollPadding: EdgeInsets.only(bottom: 40),
                textInputAction: TextInputAction.done,
                controller: _reasonController,
                maxLines: 2,
                style: TextStyle(
                    color: canEditFields ? Colors.black : Colors.grey),
                decoration: InputDecoration(
                    enabled: canEditFields,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText:
                        'Tell us the reason why you wish to raise this ${widget.isExtension ? 'claim' : 'cancellation'} *',
                    suffixStyle: const TextStyle(color: Colors.blue)),
              )),
          if (cancellationStatus == "COMPLETED")
            const SizedBox.shrink()
          else if (cancellationStatus == "IN MEDIATION" ||
              cancellationStatus == "CLAIM RAISED")
            MSButtons(
              context: context,
              size: Size(SizeConfig.widthMultiplier * 100, 50),
              borderRadius: 10,
              color: AppColors.appBlue,
              textColor: AppColors.appBlue,
              fontWeight: FontWeight.bold,
              textFontSize: 15,
              text: cancellationStatus == "CLAIM RAISED"
                  ? widget.isExtension
                      ? "CLAIM AWAITING ACCEPTANCE"
                      : "CANCELLATION IN PROGRESS"
                  : "IN MEDIATION",
              onTap: () => print('hey'),
            ).outline()
          else
            MSButtons(
              context: context,
              size: Size(SizeConfig.widthMultiplier * 100, 50),
              borderRadius: 10,
              textColor:
                  widget.isExtension ? AppColors.appBlue : AppColors.cancel_red,
              fontWeight: FontWeight.bold,
              textFontSize: 15,
              text: widget.isExtension ? 'RAISE CLAIM' : "CANCEL ORDER",
              onTap: () {
                if (widget.isExtension) {
                  // // print(_cancelOrderController.text);
                  locator.get<OrderApi>().raiseClaim(
                      _reasonController.text, _selectedOption, widget.isBuyer,
                      isExtendProtection: true);
                } else {
                  locator.get<OrderApi>().raiseClaim(
                      _reasonController.text, _selectedOption, widget.isBuyer);
                }
              },
            ).outline(
                borderColor: widget.isExtension
                    ? AppColors.appBlue
                    : AppColors.cancel_red)
        ],
      ),
    );
  }
}
