class UserResponse {
  bool? success;
  int? statusCode;
  String? message;
  UserData? data;

  UserResponse({this.success, this.statusCode, this.message, this.data});

  UserResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  String? id;
  String? email;
  String? role;
  String? status;
  Profile? profile;

  UserData({this.id, this.email, this.role, this.status, this.profile});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    role = json['role'];
    status = json['status'];
    profile = json['profile'] != null
        ? Profile.fromJson(json['profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['role'] = role;
    data['status'] = status;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? name;
  String? phone;
  String? avatar;
  String? description;

  Profile({this.name, this.phone, this.avatar, this.description});

  Profile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    avatar = json['avatar'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['avatar'] = avatar;
    data['description'] = description;
    return data;
  }
}
