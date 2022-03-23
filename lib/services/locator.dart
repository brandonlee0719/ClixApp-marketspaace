import 'package:get_it/get_it.dart';
import 'package:market_space/apis/UserProfileManager/UserProfileManager.dart';
import 'package:market_space/apis/conversation/chatManager.dart';
import 'package:market_space/apis/conversation/conversationApi.dart';
import 'package:market_space/apis/orderApi/notificationApi.dart';
import 'package:market_space/apis/orderApi/orderApi.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/apis/orderApi/walletApi.dart';
import 'package:market_space/apis/userApi/shoppingCartManager.dart';
import 'package:market_space/common/proxy/Icacher.dart';
import 'package:market_space/notification_util/notification_util.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
    locator.registerLazySingleton<NotificationUtil>(() => NotificationUtil());
    locator.registerLazySingleton<OrderApi>(() => OrderApi());
    locator.registerLazySingleton<WalletApi>(() => WalletApi());
    locator.registerLazySingleton<ShoppingCartManager>(() => ShoppingCartManager());
    // all the data of checkout us in this order manager
    locator.registerLazySingleton<OrderManager>(() => OrderManager());
    locator.registerLazySingleton<ChatManager>(() => ChatManager());
    locator.registerLazySingleton<NotificationApi>(() => NotificationApi());
    locator.registerLazySingleton(() => ConversationApi());
    locator.registerLazySingleton(() => CacheableManager());
    locator.registerLazySingleton<UserProfileManager>(() => UserProfileManager());
}


