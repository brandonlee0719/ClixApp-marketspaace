import 'package:bloc/bloc.dart';

enum ConversationCardState {
  initial,
  fetching,
  fetchSuccess,
}

class ConversationCardCubit extends Cubit<ConversationCardState> {
  ConversationCardCubit() : super(ConversationCardState.initial);
}
