class UserTileModel {
  final String? name;
  final String? lastMessage;
  final String? lastMsgTime;
  final String? img;
  final String? recipientId;

  UserTileModel({required this.recipientId, 
      required this.name,
      required this.lastMessage,
      required this.lastMsgTime,
      this.img});
}
