class MessageModel {
  String? sId;
  String? chatId;
  String? senderId;
  String? text;
  String? createdAt;
  String? updatedAt;
  bool? isRead;
  int? iV;

  MessageModel(
      {this.sId,
      this.chatId,
      this.senderId,
      this.text,
      this.createdAt,
      this.updatedAt,
      this.isRead,
      this.iV});

  MessageModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    chatId = json['chatId'];
    senderId = json['senderId'];
    text = json['text'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isRead = json['isRead'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['chatId'] = chatId;
    data['senderId'] = senderId;
    data['text'] = text;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isRead'] = isRead;
    data['__v'] = iV;
    return data;
  }



  void setIsRead(bool newIsRead) {
    isRead = newIsRead;
  }
}
