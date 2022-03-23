import 'package:flutter/cupertino.dart';

enum NotificationType{
  finance,
  order,

}

enum CryptoRouteType{
  buy,
  sell,
}

class RouteServiceProvider with ChangeNotifier{
  /*
  * although we already have a fluro package that is responsible for the routing of the application,
  * for most of the use cases, the fluro package is just hard to use and slow to implement
  * this provider is designed for a better route service, which basically store all the route parameters we need in the
  * application.
  *
  * just use the enums and ids for different routes and it is firstly faster than use fluro package
  * and secondly much much more cohesion compare to the static value in xxxroute.dar
  * */
  NotificationType type =  NotificationType.finance;

  String orderId;

  String queryProductName;

  CryptoRouteType transferRoute;

  bool isBuyer;


}