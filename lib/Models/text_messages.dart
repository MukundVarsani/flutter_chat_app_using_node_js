class TextMessages {
  TextMessages({required this.text, this.senderId});
   String text = '';
  String? senderId;


  TextMessages.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    senderId = json['senderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['senderId'] = senderId;
    return data;
  }
}
