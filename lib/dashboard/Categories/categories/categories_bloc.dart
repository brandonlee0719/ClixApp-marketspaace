import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_space/model/category/categories_model_new.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'categories_event.dart';

part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(InitialCategoriesState());
  CategoriesModel categoriesList;

  //TODO : Implement using GetIt
  AuthRepository _authRepository = AuthRepository();

  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async* {
    if (event is GetAllCategories) {
      try {
        if (state is InitialCategoriesState ||
            state is CategoriesLoadFailedState) {
          yield CategoriesLoadingState();
          categoriesList = await _authRepository.loadCategoriesFormJson();
          yield CategoriesLoadSuccessState(categoriesList,
              showHomeCategories: false, selectedCategoryIndex: 0);
        }
      } on Exception {
        yield CategoriesLoadFailedState('Categories Load failed!');
      }
    }

    if (event is CompleteDataLoadEvent) {
      yield CategoriesLoadedState(categoriesList,
          showHomeCategories: false, selectedCategoryIndex: 0);
    }

    if (event is CategorySelected) {
      try {
        if (state is CategoriesLoadSuccessState) {
          final cast = state as CategoriesLoadSuccessState;
          yield CategoriesLoadSuccessState(cast.categoryList,
              showHomeCategories: cast.showHomeCategories,
              selectedCategoryIndex: event.i);
        }
      } on Exception {
        yield CategoriesLoadFailedState('Categories Load failed!');
      }
    }

    if (event is ToggleShowHomeCategories) {
      if (state is CategoriesLoadedState) {
        final cast = state as CategoriesLoadSuccessState;
        var showHomeCats = !cast.showHomeCategories;
        yield CategoriesLoadSuccessState(cast.categoryList,
            showHomeCategories: showHomeCats,
            selectedCategoryIndex: cast.selectedCategoryIndex);
        if (!showHomeCats) add(CategorySelected(0));
      }
    }
  }
}
