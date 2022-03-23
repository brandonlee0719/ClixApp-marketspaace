part of 'buy_assets_bloc.dart';

@immutable
abstract class BuyAssetsState {}

class BuyAssetsInitial extends BuyAssetsState {}
class Initial extends BuyAssetsState {}

class Loading extends BuyAssetsState {}

class Loaded extends BuyAssetsState {}
class Failed extends BuyAssetsState {}