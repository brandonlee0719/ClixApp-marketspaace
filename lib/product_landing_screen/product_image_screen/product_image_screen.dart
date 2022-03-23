import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/product_landing_screen/product_image_screen/product_image_bloc.dart';
import 'package:market_space/product_landing_screen/product_image_screen/product_image_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:photo_view/photo_view.dart';

class ProductImageScreen extends StatefulWidget {
  @override
  _ProductImageScreenState createState() => _ProductImageScreenState();
}

class _ProductImageScreenState extends State<ProductImageScreen> {
  final ProductImageBloc _productImageBloc = ProductImageBloc(Initial());
  bool _isLoading = false;
  PageController _pageController = PageController(initialPage: 0);
  int slideIndex = 0;
  String _productName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
          title: '${ProductImageRoute.productDetailModel.productTitle}'),
      backgroundColor: AppColors.toolbarBlue,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _productImageBloc,
          child: BlocListener<ProductImageBloc, ProductImageState>(
            listener: (context, state) {
              if (state is Loading) {
                setState(() {
                  _isLoading = true;
                });
              }
              if (state is Loaded) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: _isLoading
                ? Container(
                    child: Center(
                      child: LoadingProgress(
                        color: AppColors.app_orange,
                      ),
                    ),
                  )
                : ProductImageRoute.productDetailModel == null
                    ? Container(
                        child: Center(
                          child: Text(
                            "No images available.",
                            style: GoogleFonts.inter(
                              fontSize:
                                  SizeConfig.textMultiplier * 1.757532281205165,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: _baseScreen()),
          ),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return Stack(
      children: [
        Container(
            child: PageView.builder(
          itemCount: ProductImageRoute.productDetailModel.productImages.length,
          onPageChanged: (index) {
            setState(() {
              slideIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return _imageContainer(
                ProductImageRoute.productDetailModel.productImages[index]);
          },
        )),
        if (ProductImageRoute.productDetailModel.productImages.length > 1)
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.03,
            left: MediaQuery.of(context).size.width * 0.38,
            child: _bottomSheet(true),
          ),
      ],
    );
  }

  Widget _imageContainer(String image) {
    return Container(
      child: PhotoView(
        imageProvider: NetworkImage(
          image,
        ),
        maxScale: PhotoViewComputedScale.contained * 2,
        minScale: PhotoViewComputedScale.contained * 0.8,
        // enableRotation: true,
        backgroundDecoration: BoxDecoration(
          color: AppColors.blue_900,
        ),
      ),
    );
  }

  Widget _bottomSheet(bool isCurrentPage) {
    return AnimatedContainer(
      margin: EdgeInsets.only(
        top: SizeConfig.heightMultiplier * 2.0086083213773316,
      ),
      duration: Duration(milliseconds: 500),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (int i = 0;
            i < ProductImageRoute.productDetailModel.productImages.length;
            i++)
          i == slideIndex
              ? _bottomSheetContainer(
                  true, ProductImageRoute.productDetailModel.productImages[i])
              : _bottomSheetContainer(
                  false, ProductImageRoute.productDetailModel.productImages[i]),
      ]),
    );
  }

  Widget _bottomSheetContainer(bool isCurrentPage, String image) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 0.9722222222222221),
      // height: isCurrentPage ? 8 : 8,
      // width: isCurrentPage ? 8 : 8,
      // decoration: BoxDecoration(
      //     color: isCurrentPage ? Color(0xff034AA6) : Color(0xffD4D4D4),
      //     shape: BoxShape.circle),
      child: Column(
        children: [
          CachedNetworkImage(
            height: SizeConfig.heightMultiplier * 3.7661406025824964,
            width: 30,
            imageUrl: image != null
                ? image
                : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
            placeholder: (context, url) =>
                Lottie.asset('assets/loader/image_loading.json'),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.fill,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                  color: AppColors.toolbarBlue,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.fill)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.6276901004304161),
            width: 30,
            height: SizeConfig.heightMultiplier * 0.37661406025824967,
            color: isCurrentPage
                ? AppColors.appBlue
                : AppColors.text_field_container,
          )
        ],
      ),
    );
  }
}
