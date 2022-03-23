part of add_bank;

class AddBankWidget extends StatefulWidget {
  bool isValidCard() {
    return true;
  }

  @override
  _AddBankWidgetState createState() => _AddBankWidgetState();
}

class _AddBankWidgetState extends State<AddBankWidget> {
  Map<_CheckType, TextEditingController> _controllerMap;
  _Validator _validator = _Validator();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _controllerMap = new Map<_CheckType, TextEditingController>();
    for (var value in _CheckType.values) {
      // print(value.toString());
      _controllerMap[value] = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            bottom: SizeConfig.heightMultiplier * 3.7661406025824964),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4.861111111111111,
                    top: 15),
                child: Text(
                  "Add new card",
                  style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                    fontWeight: FontWeight.w700,
                  ),
                )),
            InputContainer(
              EdgeInsets.only(
                  top: 10,
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: 16),
              _controllerMap[_CheckType.name],
              'Cardholder name',
              MediaQuery.of(context).size.width,
              EdgeInsets.only(left: 16),
            ),
            InputContainer(
                EdgeInsets.only(
                    top: 10,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: 16),
                _controllerMap[_CheckType.cardNumber],
                'Card number',
                MediaQuery.of(context).size.width,
                EdgeInsets.only(left: 16)),
            Container(
              margin: EdgeInsets.only(
                  top: 10,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884),
              child: Row(
                children: [
                  InputContainer(
                      EdgeInsets.only(
                          right:
                              SizeConfig.widthMultiplier * 1.2152777777777777),
                      _controllerMap[_CheckType.expire_date],
                      'Expiry (MM/YY)',
                      MediaQuery.of(context).size.width * 0.45,
                      EdgeInsets.only(left: 16)),
                  InputContainer(
                      EdgeInsets.only(
                          right:
                              SizeConfig.widthMultiplier * 1.2152777777777777),
                      _controllerMap[_CheckType.cvv],
                      'cvv',
                      MediaQuery.of(context).size.width * 0.3,
                      EdgeInsets.only(left: 16)),
                ],
              ),
            ),
            Builder(builder: (context) {
              final creditState = context.watch<CheckCreditBloc>().state;
              if (creditState == CheckCreditState.uploadingCard) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: Align(
                      alignment: Alignment.center,
                      child: LoadingProgress(
                        color: Colors.deepOrangeAccent,
                      )),
                );
              } else {
                return Container();
              }
            }),
            BlocListener<CheckCreditBloc, CheckCreditState>(
              listener: (context, state) {
                if (state == CheckCreditState.uploadingSuccess) {
                  // BlocProvider.of<CheckCreditBloc>(context, listen: false).add(CheckCreditEvent.checkCredit);
                  Navigator.pop(context);
                }
              },
              child: _Button(this._controllerMap, this._validator),
            ),
          ],
        ));
  }
}

class _Button extends StatefulWidget {
  final Map<_CheckType, TextEditingController> _controllerMap;
  final _Validator _validator;

  _Button(
    this._controllerMap,
    this._validator, {
    Key key,
  }) : super(key: key);

  @override
  __ButtonState createState() => __ButtonState();
}

class __ButtonState extends State<_Button> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget._validator.validate(this.widget._controllerMap)) {
          BlocProvider.of<CheckCreditBloc>(context).setBankDetails(
              widget._controllerMap[_CheckType.expire_date].text,
              widget._controllerMap[_CheckType.name].text,
              widget._controllerMap[_CheckType.cardNumber].text);
          BlocProvider.of<CheckCreditBloc>(context, listen: false)
              .add(CheckCreditEvent.uploadCredit);
          setState(() {
            _isLoading = true;
          });
        } else {
          widget._validator.validate(this.widget._controllerMap);
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Wrong input'),
              content: Text(widget._validator.messgae),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          // GlobalKeys.buyerScreenKey.currentState.showSnackBar(_validator.messgae);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: SizeConfig.heightMultiplier * 6.025824964131995,
        margin: EdgeInsets.only(
            top: 20.0,
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: 16),
        child: RaisedGradientButton(
          gradient: LinearGradient(
            colors: <Color>[
              AppColors.gradient_button_light,
              AppColors.gradient_button_dark,
            ],
          ),
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: AbsorbPointer(
                absorbing: _isLoading,
                child: Builder(builder: (context) {
                  final creditState = context.watch<CheckCreditBloc>().state;
                  if (creditState == CheckCreditState.uploadingCard) {
                    return Text(
                      'uploading......',
                      style: GoogleFonts.inter(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          letterSpacing: 0.5,
                          textStyle: TextStyle(fontFamily: 'Roboto')),
                    );
                  }

                  return Text(
                    'ADD CARD',
                    style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.5,
                        textStyle: TextStyle(fontFamily: 'Roboto')),
                  );
                }),
              )),
        ),
      ),
    );
  }
}
