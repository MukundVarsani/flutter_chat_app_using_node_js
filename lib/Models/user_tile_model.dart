class UserTileModel {
   String? name;
   String? lastMessage;
   String? lastMsgTime;
   String? img;
   String? recipientId;

  UserTileModel({required this.recipientId, 
      required this.name,
      required this.lastMessage,
      required this.lastMsgTime,
      this.img});
}
