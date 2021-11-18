class UserData {
  UserData({
    required this.password,
    required this.gender,
    required this.age,
    required this.email,
  });
  late final String password;
  late final String gender;
  late final String age;
  late final String email;

  UserData.fromJson(Map<String, dynamic> json){
    password = json['password'];
    gender = json['gender'];
    age = json['age'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['password'] = password;
    _data['gender'] = gender;
    _data['age'] = age;
    _data['email'] = email;
    return _data;
  }
}