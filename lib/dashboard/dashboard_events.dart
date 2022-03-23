import 'package:flutter/cupertino.dart';

@immutable
abstract class DashboardScreenEvents {}

class NavigateToLoginScreenEvent extends DashboardScreenEvents {}

class EbookDataEvent extends DashboardScreenEvents {}

class LikeDislikeEvent extends DashboardScreenEvents {}

class ShowCategoriesEvent extends DashboardScreenEvents {}

class AddInterestedCategoriesEvent extends DashboardScreenEvents {}

//

class CryptoRateEvent extends DashboardScreenEvents {}
