import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/common/colors.dart';

class ThemeCubit extends Cubit<ThemeData> {
  /// {@macro brightness_cubit}
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    fontFamily: 'inter',
    primaryColorDark: AppColors.toolbarBlue,
    primaryColor: AppColors.toolbarBlue,
    accentColor: AppColors.toolbarBlue,
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(color: AppColors.toolbarBlue),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: AppColors.white,
    ),
    brightness: Brightness.light,
  );

  static final _darkTheme = ThemeData(
    fontFamily: 'inter',
    primaryColorDark: AppColors.toolbarBlue,
    primaryColor: AppColors.toolbarBlue,
    primarySwatch: Colors.blue,
    accentColor: AppColors.toolbarBlue,
    appBarTheme: AppBarTheme(color: AppColors.toolbarBlue),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: AppColors.white,
    ),
    brightness: Brightness.light,
  );

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
