import 'package:flutter/cupertino.dart';

@immutable
abstract class InterestedCategoriesState {}

class Initial extends InterestedCategoriesState {}

class AddCategoriesSuccessful extends InterestedCategoriesState {}

class AddCategoriesFailed extends InterestedCategoriesState {}
