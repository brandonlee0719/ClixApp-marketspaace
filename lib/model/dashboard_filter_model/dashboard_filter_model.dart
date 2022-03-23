import 'package:equatable/equatable.dart';

class DashboardFilterModel extends Equatable {
  final List<DashboardFilterList> dashboardFilterList;

  const DashboardFilterModel({this.dashboardFilterList});

  factory DashboardFilterModel.fromJson(Map<String, dynamic> json) =>
      DashboardFilterModel(
        dashboardFilterList: (json['dashboard_filters'] as List<dynamic>)
            ?.map((e) => e == null
                ? null
                : DashboardFilterList.fromJson(e as Map<String, dynamic>))
            ?.toList(),
      );

  Map<String, dynamic> toJson() => {
        'dashboard_filters':
            dashboardFilterList?.map((e) => e?.toJson())?.toList(),
      };

  @override
  List<Object> get props => [dashboardFilterList];
}

class DashboardFilterList extends Equatable {
  final String id;
  final String name;
  final String image;
  final String searchString;
  bool selectedFilter;

  DashboardFilterList({
    this.id,
    this.name,
    this.image,
    this.searchString,
    this.selectedFilter = false,
  });

  factory DashboardFilterList.fromJson(Map<String, dynamic> json) =>
      DashboardFilterList(
        id: json['id'] as String,
        name: json['name'] as String,
        image: json['image'] as String,
        searchString: json['search_string'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'search_string': searchString,
      };

  @override
  List<Object> get props => [id, name, image, searchString];
}
