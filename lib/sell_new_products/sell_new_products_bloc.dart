import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_space/model/promo_model.dart';
import 'package:market_space/model/sell_item_req_model/sell_item_req_model.dart';
import 'package:market_space/repositories/seller_selling_repository/seller_selling_repository.dart';
import 'package:meta/meta.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:intl/intl.dart';

part 'sell_new_products_event.dart';
part 'sell_new_products_state.dart';

class SellNewProductsBloc
    extends Bloc<SellNewProductsEvent, SellNewProductsState> {
  SellNewProductsBloc(SellNewProductsState initialState) : super(initialState);

  List<PromoModel> promoList = List();
  SellerSellingRepository _sellerSellingRepository = SellerSellingRepository();
  SellItemReqModel sellItemReqModel = SellItemReqModel();
  String sellAPIStatus;
  FirebaseStorage _brandStorage =
      FirebaseStorage.instanceFor(bucket: 'market-spaace-brand-images');
  FirebaseStorage _productImageStorage =
      FirebaseStorage.instanceFor(bucket: 'market-spaace-product-images');
  String url;
  File image;
  List<String> _productImages = [];
  List<File> imageArray = [];
  final picker = ImagePicker();

  @override
  Stream<SellNewProductsState> mapEventToState(
    SellNewProductsEvent event,
  ) async* {
    if (event is ConfirmSellItemEvent) {
      yield ConfirmSellItemUploading();
      if (sellItemReqModel.isCustomBrand != null &&
          sellItemReqModel.isCustomBrand) {
        await _uploadBrandImage();
      }
      sellAPIStatus = await _sellItem();
      if (sellAPIStatus != null) {
        yield ConfirmSellItemSuccessful();
      } else {
        yield ConfirmSellItemFailed();
      }
    }

    if (event is UploadFileEvent) {
      bool result = await _pickFile();
      if (result) {
        yield FileUploadSuccessful();
      } else {
        yield FileUploadFailed();
      }
    }

    if (event is AddFromCameraEvent) {
      bool result = await _getCamera();
      if (result) {
        yield CameraUploadSuccessful();
      } else {
        yield CameraUploadFailed();
      }
    }
  }

  Future<bool> _uploadBrandImage() async {
    if (sellItemReqModel.customBrandImg != null) {
      image = File(sellItemReqModel.customBrandImg.path);
      var date = DateTime.now().millisecondsSinceEpoch;
      Reference reference = _brandStorage
          .ref()
          .child("${await FirebaseAuth.instance.currentUser.uid}_${date}");
      // ${uid}_${date}.jpg
      // print('fullPath: ${reference.fullPath}');
      //Upload the file to firebase
      UploadTask uploadTask = reference.putFile(image);

      sellItemReqModel.customBrandImgLink =
          await (await uploadTask).ref.getDownloadURL();
      // imageArray.add(url);
      return true;
    } else {
      // print('No image selected.');
      return false;
    }
  }

  Future<File> compressImage(
      File file, String targetPath, bool isThumbnail) async {
    int sizeOfFile = await file.length();
    int sizeOfFileInKb = (sizeOfFile / 1024).round();
    final size = ImageSizeGetter.getSize(FileInput(file));
    int width = size.width;
    int height = size.height;
    int resizeWidth;
    int fullQuality;
    int thumbnailQuality;
    int quality;
    double wpercent;
    double hpercent;
    int hsize;
    bool resizeByHeight;

    //set quality according to file size
    if (sizeOfFileInKb > 500) {
      fullQuality = 90;
      thumbnailQuality = 90;
    } else {
      fullQuality = 95;
      thumbnailQuality = 100;
    }

    print('size of file: ' + sizeOfFileInKb.toString());

    //set width dimensions and final quality dependening on whether it is a full image or thumbnail
    if (isThumbnail) {
      resizeWidth = 300;
      quality = thumbnailQuality;
    } else {
      resizeWidth = 700;
      quality = fullQuality;
    }

    //aspect ratios
    wpercent = (resizeWidth / width);
    hsize = (height * wpercent).round();

    resizeByHeight = false;

    //if the image is long and needs to be resized based on height
    if (hsize > 1000) {
      hsize = 1000;
      resizeByHeight = true;
    }

    if (resizeByHeight) {
      hpercent = hsize / height;
      width = (width * hpercent).round();
    }

    // print('height: ' + hsize.toString());
    // print('widght: ' + width.toString());

    DateTime date = DateTime.now();
    String targetPath = DateFormat('yyyy-MM-dd – kk:mm').format(date);
    if (isThumbnail) {
      targetPath = targetPath + "thumbnail.jpeg";
    } else {
      targetPath = targetPath + ".jpeg";
    }
    //compress image according to parameters
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: quality,
        minHeight: hsize,
        minWidth: width,
        keepExif: true,
        format: CompressFormat.jpeg);
    // print('img result returned');
    return result;
  }

  Future<String> _sellItem() async {
    UploadTask uploadTask;
    String thumbnailLink;
    String path;
    String fullPath;
    Reference reference;
    File imageData;
    if (sellItemReqModel.productImages != null) {
      for (int i = 0; i < sellItemReqModel.productImages.length; i++) {
        image = File(sellItemReqModel.productImages[i].path);
        var date = DateTime.now().millisecondsSinceEpoch;
        path = "${await FirebaseAuth.instance.currentUser.uid}_${date}";
        fullPath = path + ".jpg";
        reference = _productImageStorage.ref().child(fullPath);

        // print('fullPath: ${reference.fullPath}');
        imageData = await compressImage(image, fullPath, false);
        //Upload the file to firebase
        uploadTask = reference.putFile(imageData);
        _productImages.add(await (await uploadTask).ref.getDownloadURL());
        // print('successfully uploaded');
        if (i == 0) {
          path = path + "thumbnail.jpg";
          reference = _productImageStorage.ref().child(path);
          imageData = await compressImage(image, path, true);
          print('non compressed size: ' + image.lengthSync().toString());
          print('compressed size: ' + imageData.length().toString());
          uploadTask = reference.putFile(imageData);
          thumbnailLink = await (await uploadTask).ref.getDownloadURL();
          // print('thumbnailLink: ${thumbnailLink}');
          sellItemReqModel.thumbnailLink = thumbnailLink;
        }
      }
      sellItemReqModel.productImgLinks = _productImages;
    }
    return _sellerSellingRepository.sellItem(sellItemReqModel);
  }

  Future<bool> _pickFile() async {
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
