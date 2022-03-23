import 'package:market_space/notification/representation/widgets/components/TextInputDisplayer.dart';
import 'package:market_space/representation/listviewScreen/interfaces.dart';

class TextFieldScreenController{
  // final IWidgetDisplayer textFieldDisplayer;
  List<TextInputViewModel> viewModelList = <TextInputViewModel> [];
  final Future<void> submit;

  TextFieldScreenController({
    // this.textFieldDisplayer,
    this.submit,
    this.viewModelList,
    }
  );


}