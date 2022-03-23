import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_space/model/active_products_model/active_product_model.dart';
import 'package:market_space/model/feedback/buyer_feedback_model.dart';
import 'package:market_space/model/feedback/feedback_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/model/profile_model/profile_model.dart';
import 'package:market_space/model/promo_model.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/model/sold_product_model/sold_product_model.dart';
import 'package:market_space/profile/profile_events.dart';
import 'package:market_space/profile/profile_state.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/profile_repository/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(ProfileState initialState) : super(initialState);
  List<ProductModel> productList = List();
  List<PromoModel> promoList = List();
  File image, background_img;
  final picker = ImagePicker();
  final ProfileRepository _profileRepository = ProfileRepository();
  String bio, url, back_url, orderId;
  bool sellerData = false;
  ProfileModel profileModel;
  List<ActiveProducts> activeProductList;
  List<Orders> orders;
  List<RecentlyBrought> recentlyBoughtList;

  Stream<ProfileModel> get profileStream =>
      _profileRepository.profileProvider.profileStream;

  Stream<List<Orders>> get orderStream =>
      _profileRepository.profileProvider.Orderstream;

  Stream<List<ActiveProducts>> get activeProductStream =>
      _profileRepository.profileProvider.activeProductStream;

  Stream<List<Results>> get feedbackStream =>
      _profileRepository.profileProvider.feedbackStream;

  Stream<List<BuyerFeedback>> get feedbackBuyerStream =>
      _profileRepository.profileProvider.feedbackBuyerStream;
  FirebaseStorage _storage = FirebaseStorage.instance;
  int feedbackId = 0;

  Stream<List<RecentlyBrought>> get recentlyBoughtStream =>
      _profileRepository.profileProvider.recentlyBought;
  final AuthRepository _authRepository = AuthRepository();

  @override
  ProfileState get initialState => Initial();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    int status;
    if (event is ProfileScreenEvent) {
      yield Loading();
      profileModel = await _getProfileData();
      // await Future.delayed(Duration(milliseconds: 300));
      if (profileModel != null) {
        await _authRepository.saveProfileImage(profileModel?.profilePictureURL);
        yield Loaded();
      } else {
        yield ProfileFailed();
      }
      // print('this at recent');
      if (sellerData) {
        status = await _getSellerFeedback();
      } else {
        status = await _getBuyerFeedback();
      }
      // print('now at recent');
      if (status == 200) {
        yield Loaded();
      } else {
        yield ProfileFailed();
      }
      // print('here at recent');
      recentlyBoughtList = await _getRecentBrought();
      // print("recent bought list ${recentlyBoughtList.length}");
      if (recentlyBoughtList != null) {
        yield Loaded();
      } else {
        yield ProfileFailed();
      }
    }

    if (event is ProfileScreenOrderEvent) {
      orders = await _getSoldData();
      if (orders != null) {
        yield Loaded();
      } else {
        yield ProfileFailed();
      }
    }
    if (event is ProfileScreenActiveEvent) {
      activeProductList = await _getActiveData();
      if (activeProductList != null) {
        yield Loaded();
      } else {
        yield ProfileFailed();
      }
    }

    if (event is ProfileImagePickerEvent) {
      yield PickImage();
      bool imagePicked = await _chooseProfileImage();
      if (imagePicked) {
        yield ImagePicked();
        int status = await _setProfileUrl();
        if (status == 200) {
          yield SetProfileURLSuccessful();
        } else {
          yield SetProfileURLFailed();
        }
      } else {
        yield ImagePicFailed();
      }
    }
    if (event is ProfileImageCameraEvent) {
      yield PickImage();
      bool imagePicked = await _getCamera();
      if (imagePicked) {
        yield ImagePicked();
        int status = await _setProfileUrl();
        if (status == 200) {
          yield SetProfileURLSuccessful();
        } else {
          yield SetProfileURLFailed();
        }
      } else {
        yield ImagePicFailed();
      }
    }
    if (event is ProfileEditBioEvent) {
      yield EditBio();
      int status = await _editBio();
      if (status == 200) {
        yield EditBioSuccessful();
      } else {
        yield EditBioFailed();
      }
    }

    if (event is ProfileBackgroundEvent) {
      bool imagePicked = await _getBackgroundImage();
      if (imagePicked) {
        int status = await _setBackgroundUrl();
        if (status == 200) {
          yield SetBackgroundUrlSuccessful();
        } else {
          yield SetProfileURLFailed();
        }
      }
    }
  }

  Future<bool> _getBackgroundImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      background_img = File(pickedFile.path);
      Reference reference = _storage.ref().child("backgroundImage/");

      //Upload the file to firebase
      UploadTask uploadTask = reference.putFile(background_img);
      TaskSnapshot taskSnapshot = uploadTask.snapshot;
      back_url = await taskSnapshot.ref.getDownloadURL();
      // print("background_img $back_url");
      return true;
    } else {
      // print('No image selected.');
      return false;
    }
  }

  Future<bool> _chooseProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      String uid = FirebaseAuth.instance.currentUser.uid;
      Reference reference = _storage.ref().child("profileImage/");

      //Upload the file to firebase
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = uploadTask.snapshot;
      url = await taskSnapshot.ref.getDownloadURL();
      return true;
    } else {
      // print('No image selected.');
      return false;
    }
  }

  Future<bool> _getCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      // Uri uri =  image.uri;
      String uid = FirebaseAuth.instance.currentUser.uid;

      Reference reference = _storage.ref().child("profileImage/");

      //Upload the file to firebase
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = uploadTask.snapshot;
      url = await taskSnapshot.ref.getDownloadURL();

      return true;
    } else {
      // print('No image selected.');
      return false;
    }
  }

  Future<int> _editBio() async {
    return _profileRepository.editBio(bio, sellerData);
  }

  Future<ProfileModel> _getProfileData() async {
    return await _profileRepository.getProfileData(sellerData);
  }

  Future<int> _setProfileUrl() async {
    return await _profileRepository.setProfileUrl(url, sellerData);
  }

  Future<int> _setBackgroundUrl() async {
    return await _profileRepository.setBackgroundUrl(back_url, sellerData);
  }

  Future<List<Orders>> _getSoldData() async {
    return _profileRepository.getSoldProducts();
  }

  Future<List<ActiveProducts>> _getActiveData() async {
    return _profileRepository.getActiveProducts();
  }

  Future<int> _getSellerFeedback() async {
    return _profileRepository.getFeedback(feedbackId, true);
  }

  Future<int> _getBuyerFeedback() async {
    return _profileRepository.getFeedback(feedbackId, false);
  }

  Future<List<RecentlyBrought>> _getRecentBrought() async {
    return _profileRepository.getRecentBrought(orderId);
  }
}
