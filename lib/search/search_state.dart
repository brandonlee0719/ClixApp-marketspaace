import 'package:flutter/cupertino.dart';

@immutable
abstract class SearchState {}

class Initial extends SearchState {}

class Loading extends SearchState {}

class Loaded extends SearchState {}
