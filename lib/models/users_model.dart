
class Users {
  late String userName;
  late String userEmail;
  late String userPhone;
  late String userPassword;
  late String userCity;
  late String userAddress;

  Users(this.userName, this.userEmail, this.userPhone, this.userPassword, this.userCity, this.userAddress);

  // Users(String username, String email, String phone, String password) {
  //   userName = username;
  //   userEmail = email;
  //   userPhone = phone;
  //   userPassword = password;
  // }

  Users.fromJson(Map<dynamic, dynamic> json)
      : userName = json['userName'] as String,
        userEmail = json['userEmail'] as String,
        userPhone = json['userPhone'] as String,
        userPassword = json['userPassword'] as String,
        userCity = json['userCity'] as String,
        userAddress = json['userAddress'] as String;

  static Users? fromMap(Map value) {
    if (value == null) {
      return null;
    }

    return Users(
      value['userName'],
      value['userEmail'],
      value['userPhone'],
      value['userPassword'],
      value['userCity'],
      value['userAddress'],
    );
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'userName': userName,
    'userEmail': userEmail,
    'userPhone': userPhone,
    'userPassword': userPassword,
    'userCity': userCity,
    'userAddress': userAddress
  };

}