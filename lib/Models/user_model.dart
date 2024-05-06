class UserModel {
  String? id;
  String? name;
  String? email;
  String? token;
  String? image;

  UserModel({this.id, this.name, this.email, this.token, this.image});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    if (json.containsKey('token')) {
      token = json['token'];
    }
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    if (token != null) {
      data['token'] = token;
    }
    data['image'] = image;
    return data;
  }
}
