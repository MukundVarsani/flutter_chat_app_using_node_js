class ChatModel {
  String? sId;
  List<String>? members;

  ChatModel({this.sId, this.members});

  ChatModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    members = json['members'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['members'] = members;
    return data;
  }
}
