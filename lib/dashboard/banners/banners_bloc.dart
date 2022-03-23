import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_space/model/image_banner/image_banner.dart';
import 'package:market_space/model/image_banner/image_banner_model.dart';
import 'package:market_space/repositories/dashboardRepository/dashboard_repository.dart';
import 'package:meta/meta.dart';

part 'banners_event.dart';

part 'banners_state.dart';

class BannersBloc extends Bloc<BannersEvent, BannersState> {
  BannersBloc() : super(InitialBannersState());

  //TODO: Implement using get.IT
  final dashboardRepo = DashboardRepository();

  @override
  Stream<BannersState> mapEventToState(BannersEvent event) async* {
    // TODO: Add your event logic
    if (event is LoadBannerEvent) {
      try {
        yield BannerLoading();

        final bannerList = await _getBanner();
        yield BannerLoaded(bannerList);
      } on Exception {
        yield BannerLoadingFailed('Api Exception');
      }
    }
  }

  Future<BannerImagesModel> _getBanner() async {
    return dashboardRepo.getBanners();
  }
}
