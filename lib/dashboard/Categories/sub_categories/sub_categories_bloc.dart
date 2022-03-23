import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_space/model/category/categories_model_new.dart';
import 'package:meta/meta.dart';

part 'sub_categories_event.dart';

part 'sub_categories_state.dart';

class SubCategoriesBloc extends Bloc<SubCategoriesEvent, SubCategoriesState> {
  SubCategoriesBloc() : super(InitialSubCategoriesState());

  @override
  Stream<SubCategoriesState> mapEventToState(SubCategoriesEvent event) async* {
    if (event is ToggleShowMoreEvent) {
      yield* _mapShowMoreToState(event);
    }
    if (event is LoadSubcategories) {
      try {
          yield* _mapLoadEventToState(event);
      } on Exception {
        yield SubCategoriesLoadFailedState('Categories Load failed!!');
      }
    }
  }

  Stream<SubCategoriesState> _mapShowMoreToState(ToggleShowMoreEvent event) async* {
    if (state is SubCategoriesLoadSuccessState) {
      final castState = state as SubCategoriesLoadSuccessState;
      yield SubCategoriesLoadSuccessState(castState.subCategoriesList,
          showMore: event.showMore);
    }
  }

  Stream<SubCategoriesState> _mapLoadEventToState(LoadSubcategories event) async*{
    yield SubCategoriesLoadingState();
    final subCategories = event.subCategories;
    yield SubCategoriesLoadSuccessState(subCategories);
  }
}
