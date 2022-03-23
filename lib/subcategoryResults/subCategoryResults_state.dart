import 'package:flutter/cupertino.dart';

@immutable
abstract class SubCategoryResultsState {}

class Initial extends SubCategoryResultsState {}

class Loading extends SubCategoryResultsState {}

class Loaded extends SubCategoryResultsState {}
