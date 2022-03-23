import 'package:market_space/model/notification_model/notification.dart';
import 'package:market_space/model/notification_model/notification_model.dart';
import 'package:market_space/providers/notification_provider/notification_provider.dart';

class NotificationRepository {
  NotificationProvider notificationProvider = NotificationProvider();

  Future<List<Notifications>> getNotifications(String dateTime) async {
    return await notificationProvider.getNotifications(dateTime);
  }
}
