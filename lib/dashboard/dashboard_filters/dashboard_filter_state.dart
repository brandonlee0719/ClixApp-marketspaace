part of 'dashboard_filter_bloc.dart';

@immutable
abstract class DashboardFilterState extends Equatable {
  const DashboardFilterState();

  @override
  List<Object> get props => [];
}

class DashFilterInitial extends DashboardFilterState {
  @override
  List<Object> get props => [];
}

class DashFilterLoading extends DashboardFilterState {
  const DashFilterLoading();

  @override
  List<Object> get props => [];
}

class DashFilterLoadSuccess extends DashboardFilterState {
  final DashboardFilterModel dashboardFilterList;

  const DashFilterLoadSuccess(this.dashboardFilterList);

  @override
  List<Object> get props => [];
}

class DashFilterLoadFailed extends DashboardFilterState {
  final String errorMessage;

  const DashFilterLoadFailed(this.errorMessage);

  @override
  List<Object> get props => [];
}
