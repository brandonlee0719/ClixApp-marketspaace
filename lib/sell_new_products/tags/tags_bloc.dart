import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tags_event.dart';
part 'tags_state.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  TagsBloc(Initial initial) : super(TagsInitial());

  @override
  Stream<TagsState> mapEventToState(
    TagsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
