import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_space/common/colors.dart';
import 'package:meta/meta.dart';

part 'seller_selling_event.dart';
part 'seller_selling_state.dart';

class SellerSellingBloc extends Bloc<SellerSellingEvent, SellerSellingState> {
  SellerSellingBloc(SellerSellingState initialState) : super(initialState);
  File image, background_img;
  final picker = ImagePicker();

  FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'market-spaace-product-images');
  String bio, url, back_url, orderId;
  List<File> imageArray = List();
  String uid = FirebaseAuth.instance.currentUser.uid;
  @override
  Stream<SellerSellingState> mapEventToState(
    SellerSellingEvent event,
  ) async* {
    if (event is SellerSellingScreenEvent) {
      yield Loading();
      await Future.delayed(Duration(microseconds: 300));
      yield Loaded();
    }

    if (event is SellNewProductsImageEvent) {
      bool isImagePick = await _chooseProfileImage();
      if (isImagePick) {
        yield ImagePick();
      } else {
        yield ImagePickFailed();
      }
    }

    if (event is SellNewProductsCameraEvent) {
      bool isCameraPick = await _getCamera();
      if (isCameraPick) {
        yield CameraPick();
      } else {
        yield CameraPickFailed();
      }
    }
  }

  Future<bool> _chooseProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      // var date = DateTime.now().millisecondsSinceEpoch;
      // Reference reference = _storage.ref().child("${uid}_${date}");
      // // ${uid}_${date}.jpg
      // // print('fullPath: ${reference.fullPath}');
      // //Upload the file to firebase
      // UploadTask uploadTask = reference.putFile(image);

      // url = await (await uploadTask).ref.getDownloadURL();
      // imageArray.add(url);
      imageArray.add(image);
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

      // Reference reference = _storage.ref().child("sellingItemImage/");

      // //Upload the file to firebase
      // UploadTask uploadTask = reference.putFile(image);
      // // TaskSnapshot taskSnapshot = uploadTask.snapshot;
      // url = await (await uploadTask).ref.getDownloadURL();
      imageArray.add(image);
      return true;
    } else {
      // print('No image selected.');
      return false;
    }
  }
}
