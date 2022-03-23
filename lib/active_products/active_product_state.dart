import 'package:flutter/cupertino.dart';

@immutable
abstract class ActiveProductsState {}

class Initial extends ActiveProductsState {}

class Loading extends ActiveProductsState {}

class Loaded extends ActiveProductsState {}

class Failed extends ActiveProductsState {}
