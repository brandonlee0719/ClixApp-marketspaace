import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/common/common_widgets.dart';
import 'package:market_space/common/header_dashboard.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/sub_categories_widget.dart';
import 'package:market_space/dashboard/banner_widget.dart';
import 'package:market_space/dashboard/dashboard_filters.dart';
import 'package:market_space/dashboard/flash_products_widget.dart';
import 'package:market_space/dashboard/products/products_bloc.dart';
import 'package:market_space/dashboard/products_grid.dart';
import 'package:market_space/common/colors.dart';

class DashboardWrapper extends StatelessWidget {
  // final DashboardScreenBloc _dashboardScreenBloc =
  //     DashboardScreenBloc(Initial());

  @override
  Widget build(BuildContext context) {
    return DashboardNew();
    // return BlocProvider(
    //   create: (_) => _dashboardScreenBloc,
    //   child: DashboardNew(),
    // );
  }
}

class DashboardNew extends StatefulWidget {
  const DashboardNew({Key key}) : super(key: key);

  @override
  _DashboardNewState createState() => _DashboardNewState();
}

class _DashboardNewState extends State<DashboardNew>
    with AutomaticKeepAliveClientMixin {
  final _sc = ScrollController();
  // ValueNotifier valueNotifier = new ValueNotifier(0);

  //TODO: Implement Using GetIt

  // BlocProvider.of<ProductsBloc>(context)
  //       .add(LoadListEvent());

  @override
  void initState() {
    // context.read<ProductsBloc>().add(LoadListEvent());
    _sc.addListener(() {
      // print('sc offset: ${_sc.offset}' + _sc.offset.toString());
      // print('position: ${_sc.position.maxScrollExtent}}');
      if ((_sc.position.maxScrollExtent - _sc.offset) <= 300) {
        // print("ENNND");
        // print('this entered');
        // print('more products loading');
        context.read<ProductsBloc>().add(LoadMoreProductsEvent());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            HeaderDashboard(),
            Expanded(
                child: SingleChildScrollView(
                    controller: _sc,
                    child: Column(
                      children: [
                        SubCategoriesWrapper(),
                        FlashProductsWidget(),
                        BannerWidget(),
                        yHeight3,
                        DashboardFilter(),
                        ProductsGridWrapper(),
                        yHeight3,
                        Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    AppColors.app_orange))),
                        SizedBox(height: 25.0)
                      ],
                    )))
          ],
        ));
  }

  bool get wantKeepAlive => true;
}
