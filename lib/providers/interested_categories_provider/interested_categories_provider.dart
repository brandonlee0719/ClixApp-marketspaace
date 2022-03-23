import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/interestingCategories/interesting_categories_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

class InterestedCategoriesProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _token;
  int _productStatus;

  Future<String> addInterestedItems(List<String> itemList) async {
    final createUserUrl = '$_baseUrl${Constants.add_interested_categories}';
    _token = await _authRepository.getUserFirebaseToken();
    // _token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjNlNTQyN2NkMzUxMDhiNDc2NjUyMDhlYTA0YjhjYTZjODZkMDljOTMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vbWFya2V0LXNwYWFjZSIsImF1ZCI6Im1hcmtldC1zcGFhY2UiLCJhdXRoX3RpbWUiOjE2MDU2OTQxNzcsInVzZXJfaWQiOiJ6dnVqNWFxUnQwVktoV204NXJ0emh5VXFLcjIyIiwic3ViIjoienZ1ajVhcVJ0MFZLaFdtODVydHpoeVVxS3IyMiIsImlhdCI6MTYwNTY5NDE3NywiZXhwIjoxNjA1Njk3Nzc3LCJlbWFpbCI6ImVyYW5raXQ0dXVAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImVyYW5raXQ0dXVAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.Ke9F3mdtfM1qN2Qwr1sjve0H1jlZ35PsRx7a__nwdwHrtaUGfE-93qgpJO-EOGUE_4YNEbSCKfGNIrACPlxjwBYSKh7IsjPr22lUlztcxiAZGTeKFAj8B6pOi0IHZLrE0sPnwsKEIoI_iItBQIuOFlApkJuAet34F9tPibxcF1mrURxTtkqZzfVppTs2FTl_ivzkaUqx4WilKpWmMYbZHAuzcQmLsDLlubeEbgvOU4X-fV4KKrpkF6a53YTkUMZR3BuatQ-dUuBGpESF5Ler5BI83h_5HcpJ6z8zEVsP_qwXhh_o_vtdDMVAzCPB90jF2nRt6v9QPIH3Be7wzwjvQQ";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"interestedCategories": itemList},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _productStatus = status;
            return status < 500;
          }),
    );
    // print(response.data.toString());
    // print(createUserUrl);
    // print(response.headers);

    if (_productStatus == 200) {
      await _authRepository.saveCategoryAdded("true");
      InterestingCategoriesModel model = InterestingCategoriesModel();
      model.interstingCategories = [];
      model.interstingCategories.addAll(Constants.selectedChoices);
      // HashMap<String, InterestingCategoriesModel> intMap = HashMap();
      // intMap["interestingCategories"] = model;
      // var cat = InterestingCategoriesModel.fromJson('');
      await _authRepository.saveInterestingCategories(model);
      // print("success ${_productStatus}");
      return response.data.toString();
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return response.data.toString();
    }
  }
}
