import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/repositories/dashboardRepository/dashboard_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'flash_event.dart';
part 'flash_state.dart';

class FlashBloc extends Bloc<FlashEvent, FlashState> {
  final List<FlashPromoAlgoliaObj> flashList = [];

  FlashBloc() : super(FlashInitial());
  final dashboardRepo = DashboardRepository();

  int pageCount = 0;
  String categoryFilter;
  bool subCatSelected = false;
  String subCatText;
  String newSubCategoryText;
  List<FlashPromoAlgoliaObj> flashLoadMoreList = [];
  bool showFlash = true;

  // ignore: close_sinks
  BehaviorSubject<List<FlashPromoAlgoliaObj>> sink = BehaviorSubject();

  // get getshowFlash => showFlash;

  // void setShowFlash(bool visibility) {
  //   showFlash = visibility;
  // }

  @override
  Stream<FlashState> mapEventToState(
    FlashEvent event,
  ) async* {
    if (event is LoadFlashPromoEvent) {
      try {
        yield FlashLoadingState();
        pageCount = 0;
        flashList.clear();
        yield* _loadFlashProducts();
      } on Exception {
        yield FlashLoadFailedState('Api Load failed !!!');
      }
    }

    if (event is LoadMoreFlashPromoEvent) {
      final cast = state as FlashLoadSuccessState;
      if (cast.showLoader) {
        pageCount++;
        yield* _loadFlashProducts();
      }
    }

    // if (event is HideFlash) {
    //   yield FlashHide();
    // }

    // if (event is ShowFlash) {
    //   yield FlashShow(flashLoadMoreList);
    // }
  }

  Stream<FlashState> _loadFlashProducts() async* {
    final lst = await dashboardRepo.dashboardProvider.flashWithAlgolia(
        pageCount,
        categoryFilter,
        subCatSelected,
        subCatText,
        newSubCategoryText);
    flashList.addAll(lst);
    // print("FLASH LIST LENGTH = ${flashList.length}");
    yield FlashLoadSuccessState(
        List<FlashPromoAlgoliaObj>.from(flashList), showFlash,
        showLoader: lst.length > 0);
  }
}
