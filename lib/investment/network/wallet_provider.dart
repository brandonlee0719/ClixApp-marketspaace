import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/image_banner/image_banner.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:market_space/model/image_banner/image_banner.dart';
import 'package:market_space/model/image_banner/image_banner_model.dart';

class WalletProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();

  int _bannerStatus;
  String _token;

  final BehaviorSubject<List<String>> _bannerSink = BehaviorSubject();

  Stream<List<String>> get bannerStream => _bannerSink.stream;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Response response;

  // to-do make it shared code
  BaseOptions setOptions() {
    // this is for setting the request the
    BaseOptions options = new BaseOptions(
      baseUrl: _baseUrl,
      contentType: 'application/json',
      validateStatus: (status) {
        return status <= 500;
      },
    );

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = '*/*';
    options.headers['Connection'] = 'keep-alive';

    return options;
  }

  // to-do research if I should use async and async*
  // to-do test mock server ;
  // to-do fix other cases;
  Future<int> getResponse() async {
    var options = setOptions();

    // print(options);
    dio.options = options;
    // dio.options.headers["Authorization"] = "Bearer jkncjvdbvdkbsbvusaivbsjvbjkssjbv";
    // String prefCurrency = await _authRepository.getPrefferedCurrency();
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    // print('here');
    response = await dio.post(
      '/get_asset_balance',
      data: {"prefCurrency": 'AUD'},
    );
    // print(response.data);
    return response.statusCode;
  }

  Future<BannerImagesModel> getBannersList() async {
    String banner = await _authRepository.getBanner();
    BannerImagesModel ibanner;
    String bannerDateStr = await _authRepository.getBannerDate();
    var difference;
    var currentDate;

    //check if a day has passed since the last banners have loaded
    if (bannerDateStr != null) {
      currentDate = DateTime.now();
      difference = currentDate.difference(DateTime.parse(bannerDateStr)).inDays;
    }

    //lood from database if no banners saved or last banners loaded has been more than a day - otherwise load the saved image urls locally
    if (banner == null || difference != null && difference > 1) {
      ibanner = await loadBannersFromNetwork();
      // print("Load banners from Network");
      _bannerSink.add(ibanner.imgUrLs);
      // print(jsonEncode(ibanner.toJson()));
      _authRepository.saveBanner(ibanner.toJson());
      currentDate = DateTime.now();
      _authRepository.saveBannerDate(currentDate.toString());
    } else {
      // print("Load banners from Local Response");
      Map<String, dynamic> constructedBanner = jsonDecode(banner);
      ibanner = BannerImagesModel.fromJson(constructedBanner);
      // currentDate = DateTime.now();
      // print('current date' + currentDate.toString());
    }
    return ibanner;
  }

  Future<BannerImagesModel> loadBannersFromNetwork() async {
    {
      // print('we are obtaining new images');
      final createUserUrl = '$_baseUrl${Constants.get_banner}';
      _token = await _authRepository.getUserFirebaseToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer $_token";
      dio.options.baseUrl = _baseUrl;
      final Response response = await dio.get(
        createUserUrl,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              _bannerStatus = status;
              return status < 500;
            }),
      );
      // print(response.data);
      // print(createUserUrl);
      // print(response.headers);

      var banner = BannerImagesModel.fromJson(response.data);
      var urls = banner.imgUrLs;
      for (var i = 0; i < urls.length; i++) {
        // print('banner img: ' + urls[i]);
      }

      // print(banner.imgUrLs);

      if (_bannerStatus == 200) {
        // print("success ${_bannerStatus}");
        // final birthday = DateTime(1967, 10, 12);
        final date2 = DateTime.now();
        // final difference = date2.difference(birthday).inDays;
        _authRepository.saveBannerDate(date2.toString());
        _authRepository.saveBanner(banner);
        return banner;
      } else {
        return banner;
      }
    }
  }
}
