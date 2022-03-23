import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:market_space/subcategoryResults/subCategoryResults_screen.dart';
import 'package:market_space/model/sub_category_results_model/sub_category_results_model.dart';
import 'package:market_space/routes/route.dart';

class SubCategoryResultsRoute extends ARoute {
  static String _path = '/dashboard/subCategoryResults';
  static String buildPath() => _path;
  static SubCategoryResultsModel subCategoryResultsModel =
      SubCategoryResultsModel();
  @override
  String get path => _path;

  // @override
  // final bool clearStack = true;

  @override
  final TransitionType transition = TransitionType.inFromRight;

  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      SubCategoryResultsScreen();
}
