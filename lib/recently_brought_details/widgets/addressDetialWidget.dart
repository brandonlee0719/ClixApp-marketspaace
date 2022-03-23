import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/mixins/submitMixin.dart';
import 'package:market_space/providers/interfaces/IshippingProvider.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:rxdart/rxdart.dart';

class ShippingDetail{
  final String shippingCompany;
  final String trackingNumber;

  ShippingDetail(this.shippingCompany, this.trackingNumber);
  Map<String, dynamic> toJson(){
    return {
      "shippingCompany":shippingCompany,
      "trackingNumber": trackingNumber,
    };
  }
}

class AddressDetailWidget extends StatefulWidget {
  @override
  _AddressDetailWidgetState createState() => _AddressDetailWidgetState();
}

class _AddressDetailWidgetState extends State<AddressDetailWidget> with InputScreenMixin{
  ShippingAddressInputBloc<ShippingDetail> bloc = ShippingAddressInputBloc<ShippingDetail>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InputState>(
      stream: bloc.getStream(),
      builder: (context, snapshot) {
        String title = "Order Status";
        Widget child;
        if(!snapshot.hasData){
          child = Text("Loading");
        }
        else if(snapshot.data == InputState.noModel){
          title = "Has the item been shipped?";
          child = _noModelScreen();
        }
        else if(snapshot.data == InputState.await_loading){
          child = Text("Loading");
        }
        else{
          child = Text("has a model");
        }
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: SizeConfig.widthMultiplier*3,
                top: 12),
                child: Text(
                title,
                style: GoogleFonts.inter(
                color: AppColors.app_txt_color,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1),
                ),
              ),
            ),
            child,
          ],
        );
      }
    );
  }

  _noModelScreen(){
    return Column(
      children: [
        buildScreen(bloc),
        ButtonBuilder().build(ButtonSection(ButtonSectionType.confirmButton, "CONFIRM SHIPPING DETAILS", bloc.submit)),
        Container(
            padding: EdgeInsets.only(left: SizeConfig.widthMultiplier*3,right: SizeConfig.widthMultiplier*3),
            child: ButtonBuilder().build(ButtonSection(ButtonSectionType.blueButton, "MARK ITEM AS SHIPPED", bloc.submit)))
      ],
    );
  }
}


class ShippingAddressInputBloc<T extends ShippingDetail> implements IInputScreenBloc{
  List<CustomizedTextField> fields = [
    CustomizedTextField("TrackingNumber", "TrackingNumber", new TextEditingController()),
    CustomizedTextField("Shipping company", "Shipping company", new TextEditingController()),
  ];
  ShippingDetail model;

  BehaviorSubject<InputState> _stateSink = BehaviorSubject<InputState>();
  Stream<InputState> _inputStateStream;
  IShippingProvider provider = MockShippingProvider();

  dispose(){
    _stateSink.close();
  }
  ShippingAddressInputBloc(){
    _init();
  }

  Future<void> _init() async{
    _inputStateStream = _stateSink.stream;
    _stateSink.add(InputState.await_loading);
    this.model = await provider.getDetail("110");
    if(this.model != null){
      _stateSink.add(InputState.hasModel);
    }
    else{
      _stateSink.add(InputState.noModel);
    }

  }

  @override
  List<CustomizedTextField> getFields() {
    return fields;
  }

  @override
  ShippingDetail getModel()  {
    return ShippingDetail(fields[0].controller.text, fields[1].controller.text);
  }

  @override
  Future<ShippingDetail> getModelFromRemote() async{
    // TODO: implement getModelFromRemote
    return await provider.getDetail("ms227");
  }

  @override
  Stream<InputState> getStream() {
    return _inputStateStream;
  }

  @override
  Future<void> submit() async {
    _stateSink.add(InputState.await_loading);
    int code = await provider.uploadShipping(getModel());
    if(code == 200){
      _stateSink.add(InputState.hasModel);
      model = getModel();
      return;
    }
    _stateSink.add(InputState.noModel);
  }

}
