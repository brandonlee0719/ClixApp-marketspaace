import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:market_space/search/search_events.dart';
import 'package:market_space/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(SearchState initialState) : super(initialState);

  final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics;
  List<BiometricType> availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool isAuthorized = false;

  @override
  SearchState get initialState => Initial();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is NavigateToHomeScreenEvent) {
      yield Loading();
      await Future.delayed(Duration(
          seconds: 1)); // This is to simulate that above checking process
      yield Loaded(); // In this state we can load the HOME PAGE
    }
  }
}
