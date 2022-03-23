import 'package:flutter_bloc/flutter_bloc.dart';
import 'interested_categories_events.dart';
import 'interested_categories_state.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/repositories/interestedCategoriesRepository/interestedCategoriesRepository.dart';

class InterestedCategoriesBloc
    extends Bloc<InterestedCategoriesEvents, InterestedCategoriesState> {
  InterestedCategoriesBloc(InterestedCategoriesState initialState)
      : super(initialState);

  final interestedCategoriesRepo = InterestedCategoriesRepo();
  String addedCategoriesStatus;

  @override
  InterestedCategoriesState get initialState => Initial();

  @override
  Stream<InterestedCategoriesState> mapEventToState(
    InterestedCategoriesEvents event,
  ) async* {
    if (event is NavigateToAddInterestedCategoriesEvent) {
      addedCategoriesStatus = await _addInterestedItems();
      if (addedCategoriesStatus != null) {
        yield AddCategoriesSuccessful();
      } else {
        yield AddCategoriesFailed();
      }
    }
  }

  Future<String> _addInterestedItems() async {
    return await interestedCategoriesRepo.interestedCategoriesProvider
        .addInterestedItems(Constants.selectedChoices);
  }
}
