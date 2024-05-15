class UserTileModel {
  String? name;
  String? lastMessage;
  String? lastMsgTime;
  String? img;
  String? recipientId;
  bool? isRead;

  UserTileModel(
      {required this.recipientId,
      required this.name,
      required this.lastMessage,
      required this.lastMsgTime,
      required this.isRead,

      this.img});
}
