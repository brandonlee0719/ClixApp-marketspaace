part of 'tags_bloc.dart';

@immutable
abstract class TagsState {}

class TagsInitial extends TagsState {}

class Initial extends TagsState {}

class Loading extends TagsState {}

class Loaded extends TagsState {}
