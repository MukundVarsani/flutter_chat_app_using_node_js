class ApiEndPoints {
  ApiEndPoints._();

// ============================USER============================
  static const String login = "users/login";
  static const String register = 'users/register';
  static const String allUser = 'users/';
  static const String findUser = 'users/find/';
  static const String updateImage = 'users/update-image';

  // ===================================CHATS========================
  static const String createChat = 'chats/';
  static const String getUserChat = 'chats/';
  static const String findChat = 'chats/find/';

//  ========================================message========================
  static const String createMesssage = 'messages';
  static const String getMessage = 'messages/';

  //=========================================== Notification=============================

  static const String sendNotification = '/send-notification';
}
