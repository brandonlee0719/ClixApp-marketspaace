import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/common/common_widgets.dart';
import 'package:market_space/common/shimmers/shimmer_dash_filters.dart';
import 'package:market_space/dashboard/dashboard_filters/dashboard_filter_bloc.dart';
import 'package:market_space/dashboard/products/products_bloc.dart';
import 'package:market_space/model/dashboard_filter_model/dashboard_filter_model.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'Categories/categories/categories_bloc.dart';

class DashboardFilter extends StatefulWidget {
  const DashboardFilter({Key key}) : super(key: key);

  @override
  _DashboardFilterState createState() => _DashboardFilterState();
}

class _DashboardFilterState extends State<DashboardFilter> {
  @override
  void initState() {
    super.initState();
    getFilters();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardFilterBloc, DashboardFilterState>(
        builder: (bContext, state) {
      if (state is DashFilterLoading) {
        return ShimmerDashFilter();
      } else if (state is DashFilterLoadSuccess) {
        return _filterWidget(state.dashboardFilterList);
      } else if (state is DashFilterLoadFailed) {
        return retryErrorBtn('Some errors on fetch Filters', () {
          getFilters();
        });
      } else {
        return ShimmerDashFilter();
      }
    });
  }

  Widget _filterWidget(DashboardFilterModel filterModel) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 100) / 3;
    final double itemWidth = size.width / 2;
    return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 15),
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 0,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        itemCount: filterModel.dashboardFilterList.length,
        itemBuilder: (BuildContext ctx, i) {
          return Column(
            children: [
              GestureDetector(
                  onTap: () {
                    final bloc = context.read<DashboardFilterBloc>();
                    final state = context.read<CategoriesBloc>().state as CategoriesLoadSuccessState;
                    bloc.selectedToggle(i);
                    final filters = bloc.filterList.dashboardFilterList;
                    BlocProvider.of<ProductsBloc>(context)
                        .add(FilterChangedEvent(
                      preLoved: filters[0].selectedFilter,
                      digital: filters[1].selectedFilter,
                      international: filters[2].selectedFilter,
                      local: filters[3].selectedFilter,
                      category:  state
                          .categoryList
                          .categoriesList[state.selectedCategoryIndex]
                          .algoliaSearchString
                    ));
                    bloc.close();
                    setState(() {});
                  },
                  child: _imageContainer(
                      '${filterModel.dashboardFilterList[i].image}',
                      filterModel.dashboardFilterList[i].selectedFilter)),
              yHeight05,
              Text(
                '${filterModel.dashboardFilterList[i].name}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 1.6 * SizeConfig.textMultiplier),
              ),
            ],
          );
        });
  }

  Widget _imageContainer(String url, bool selected) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(1.5 * SizeConfig.heightMultiplier),
      decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ]),
      child: Image.asset(
        '$url',
        color: selected ? Colors.white : Theme.of(context).primaryColor,
        height: 7 * SizeConfig.imageSizeMultiplier,
        fit: BoxFit.contain,
      ),
    );
  }

  void getFilters() {
    BlocProvider.of<DashboardFilterBloc>(context).add(GetFilters());
  }
}
