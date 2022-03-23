import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/representation/cards.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

abstract class IShow {
  void show();
}

abstract class IState {
  StateContext context;
  Future nextState(StateContext context);
  Widget render();
}

class StateContext {
  StreamController<IState> _stateStream = StreamController<IState>();
  Sink<IState> get _stateSink => _stateStream.sink;
  Stream<IState> get outerSink => _stateStream.stream;
  IState currentState;
  UpdateAddressModel model;

  StateContext() {
    this.currentState = LoadingWidget();
  }

  void setState(IState state) {
    currentState = state;
    if (state != null) {
      state.context = this;
    }
    _stateSink.add(state);
  }

  void dispose() {
    _stateStream.close();
  }

  Future<void> nextState() async {
    await currentState.nextState(this);
  }
}

class LoadingWidget implements IState {
  @override
  Future nextState(StateContext context) async {
    await locator.get<OrderManager>().getAddress();
    context.setState(AddressWidget());
  }

  @override
  Widget render() {
    // TODO: implement render
    return Text("Loading");
  }

  @override
  StateContext context;
}

class AddressWidget implements IState {
  ValueNotifier<int> notifier = ValueNotifier(-1);
  @override
  StateContext context;
  @override
  Future nextState(StateContext context) async {
    context.model =
        locator.get<OrderManager>().billingAddresses[notifier.value];
    context.setState(null);
  }

  @override
  Widget render() {
    notifier.addListener(() async {
      if (notifier.value >= 0) {
        await Future.delayed(Duration(milliseconds: 500));
        nextState(context);
      }
    });
    return Column(
      children: [
        for (int i = 0;
            i < locator.get<OrderManager>().billingAddresses.length;
            i++)
          CardBuilder().build(CardSection(
            CardSectionType.AddressCard,
            model: locator.get<OrderManager>().billingAddresses[i],
            value: i,
            groupValue: notifier,
          ))
      ],
    );
  }
}

mixin ChooseBillingMixin<T extends StatefulWidget> on State<T>
    implements IShow {
  StateContext _myState = StateContext();

  @override
  Future<UpdateAddressModel> show() async {
    _myState.nextState();

    return await showMaterialModalBottomSheet(
      context: context,
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: StreamBuilder<IState>(
              initialData: LoadingWidget(),
              stream: _myState.outerSink,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  // print(_myState.model.toJson());
                  _myState.dispose();
                  Navigator.pop(context, _myState.model);
                }
                if (snapshot.data != null) {
                  return snapshot.data.render();
                }
                return Text('done');
              })),
    );
  }
}
