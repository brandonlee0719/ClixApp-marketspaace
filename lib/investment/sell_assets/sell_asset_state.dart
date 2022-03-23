part of 'sell_asset_bloc.dart';

@immutable
abstract class SellAssetState {}

class SellAssetInitial extends SellAssetState {}
class Loading extends SellAssetState {}

class Loaded extends SellAssetState {}
class Failed extends SellAssetState {}