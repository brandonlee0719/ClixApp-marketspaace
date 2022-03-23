import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_space/model/dashboard_filter_model/dashboard_filter_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'dashboard_filter_event.dart';
part 'dashboard_filter_state.dart';

class DashboardFilterBloc
    extends Bloc<DashboardFilterEvent, DashboardFilterState> {
  DashboardFilterBloc() : super(DashFilterInitial());

  AuthRepository _authRepository = AuthRepository();

  DashboardFilterModel filterList;

  bool selectedToggle(int index) {
    filterList.dashboardFilterList[index].selectedFilter =
        !filterList.dashboardFilterList[index].selectedFilter;
    return filterList.dashboardFilterList[index].selectedFilter;
  }

  @override
  Stream<DashboardFilterState> mapEventToState(
    DashboardFilterEvent event,
  ) async* {
    if (event is GetFilters) {
      try {
        yield DashFilterLoading();

        filterList = await _authRepository.loadDashFiltersFormJson();
        // print("Filter List is ====> ${filterList.toJson()}");
        yield DashFilterLoadSuccess(filterList);
      } on Exception {
        yield DashFilterLoadFailed('Api Exception');
      }
    }
  }
}
