import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/common/common_widgets.dart';
import 'package:market_space/common/slide_right_transition.dart';
import 'package:market_space/dashboard/Categories/categories/categories_bloc.dart';
import 'package:market_space/dashboard/Categories/sub_categories/sub_categories_bloc.dart';
import 'package:market_space/dashboard/products_page.dart';
import 'package:market_space/model/category/categories_model_new.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class SubCategoriesWrapper extends StatelessWidget {
  const SubCategoriesWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      buildWhen: (prev, current) {
        if (prev is CategoriesLoadingState &&
            current is CategoriesLoadSuccessState) {
          return true;
        }
        return prev is CategoriesLoadSuccessState &&
            current is CategoriesLoadSuccessState &&
            (prev.selectedCategoryIndex != current.selectedCategoryIndex);
      },
      builder: (context, state) {
        if (state is CategoriesLoadSuccessState)
          return BlocProvider.value(
            value: context.read<SubCategoriesBloc>()
              ..add(LoadSubcategories(state.categoryList
                  .categoriesList[state.selectedCategoryIndex].subCategories)),
            child: SubCategoriesWidget(),
          );
        return Container();
      },
    );
  }
}

class SubCategoriesWidget extends StatefulWidget {
  SubCategoriesWidget({Key key}) : super(key: key);

  @override
  _SubCategoriesWidgetState createState() => _SubCategoriesWidgetState();
}

class _SubCategoriesWidgetState extends State<SubCategoriesWidget> {
  List<SubCategories> lessCategoryList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubCategoriesBloc, SubCategoriesState>(
        builder: (bContext, state) {
      // print("SubcategoriesState : $state");
      if (state is SubCategoriesLoadingState) {
        return Text('Loading Categories');
      } else if (state is SubCategoriesLoadSuccessState) {
        return subCard(state);
      } else if (state is SubCategoriesLoadFailedState) {
        return Text('No Data found');
      } else {
        return Container();
      }
    });
  }

  Widget subCard(SubCategoriesLoadSuccessState subState) {
    final data = subState.subCategoriesList.length > 9 && !subState.showMore
        ? subState.subCategoriesList.sublist(0, 9)
        : subState.subCategoriesList;
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.2;
    final double itemWidth = size.width / 2;
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoadSuccessState) {
          if (!state.showHomeCategories || data.isEmpty)
            return SizedBox.shrink();
        }
        return Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: GridView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: (itemWidth / itemHeight),
                ),
                children: [
                  for (final i in data)
                    InkWell(
                      onTap: () {
                        // print("Clicked ${i.algoliaSearchString}");
                        // Navigate to View product releated on sub categories
                        // Navigator.push(
                        //     context,
                        //     CupertinoPageRoute(
                        //         builder: (c) => ProductsPage(
                        //               algoliaString: i.algoliaSearchString,
                        //             )));

                        Navigator.push(
                            context,
                            SlideRightRoute(
                                page: ProductsPageWrapper(
                              algoliaString: i.algoliaSearchString,
                            )));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            i.subCategoryImage,
                            height: 15 * SizeConfig.imageSizeMultiplier,
                            fit: BoxFit.contain,
                          ),
                          yHeight05,
                          Text(
                            i.subCategoryName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 1.6 * SizeConfig.textMultiplier),
                          ),
                        ],
                      ),
                    ),
                  if (subState.subCategoriesList.length > 9)
                    InkWell(
                      onTap: () {
                        BlocProvider.of<SubCategoriesBloc>(context)
                            .add(ToggleShowMoreEvent(!subState.showMore));
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 15 * SizeConfig.imageSizeMultiplier,
                            child: Icon(
                                subState.showMore
                                    ? Icons.arrow_circle_up_outlined
                                    : Icons.arrow_drop_down_circle_outlined,
                                color: Theme.of(context).primaryColor,
                                size: 8 * SizeConfig.imageSizeMultiplier),
                          ),
                          yHeight05,
                          Text(
                            subState.showMore ? "Less" : 'More',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 1.6 * SizeConfig.textMultiplier),
                          ),
                        ],
                      ),
                    ),
                ]),
          ),
        );
      },
    );
  }

  Widget moreBtn() {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.arrow_drop_down_circle_outlined,
              color: Theme.of(context).primaryColor,
              size: 8 * SizeConfig.imageSizeMultiplier),
          yHeight05,
          Text(
            'More',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 1.4 * SizeConfig.textMultiplier),
          ),
        ],
      ),
    );
  }
}
