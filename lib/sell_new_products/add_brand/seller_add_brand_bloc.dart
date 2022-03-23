import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:market_space/repositories/seller_selling_repository/brand_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'seller_add_brand_event.dart';
part 'seller_add_brand_state.dart';

class SellerAddBrandBloc
    extends Bloc<SellerAddBrandEvent, SellerAddBrandState> {
  SellerAddBrandBloc(SellerAddBrandState initialState) : super(initialState);

  String brandImage;
  List<String> brandItems;
  final BrandRepository _brandRepository = BrandRepository();
  final picker = ImagePicker();
  File image;
  @override
  Stream<SellerAddBrandState> mapEventToState(
    SellerAddBrandEvent event,
  ) async* {
    if (event is LoadAvailableBrands) {
      yield BrandsLoading();
      brandItems = await _handlingItems();
      yield BrandsLoaded();
    }

    if (event is PickImage) {
      yield PickingImage();
      await _setBrandImage();
      yield PickedImage();
    }
    // TODO: implement mapEventToState
  }

  Future<List<String>> _handlingItems() {
    return _brandRepository.getAvailableBrands();
  }

  Future<bool> _setBrandImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      // var date = DateTime.now().millisecondsSinceEpoch;
      // Reference reference = _storage.ref().child("${uid}_${date}");
      // // ${uid}_${date}.jpg
      // // print('fullPath: ${reference.fullPath}');
      // //Upload the file to firebase
      // UploadTask uploadTask = reference.putFile(image);
      // ;

      // url = await (await uploadTask).ref.getDownloadURL();
      // imageArray.add(url);
      return true;
    } else {
      // print('No image selected.');
      return false;
    }
  }
}
