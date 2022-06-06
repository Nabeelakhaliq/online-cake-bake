
class Admin {
  late String adminName;
  late String adminEmail;
  late String adminPhone;
  late String adminPassword;

  Admin(this.adminName, this.adminEmail, this.adminPhone, this.adminPassword);

  // Users(String username, String email, String phone, String password) {
  //   userName = username;
  //   userEmail = email;
  //   userPhone = phone;
  //   userPassword = password;
  // }

  Admin.fromJson(Map<dynamic, dynamic> json)
      : adminName = json['adminName'] as String,
        adminEmail = json['adminEmail'] as String,
        adminPhone = json['adminPhone'] as String,
        adminPassword = json['adminPassword'] as String;

  static Admin? fromMap(Map value) {
    if (value == null) {
      return null;
    }

    return Admin(
      value['adminName'],
      value['adminEmail'],
      value['adminPhone'],
      value['adminPassword'],
    );
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'adminName': adminName,
    'adminEmail': adminEmail,
    'adminPhone': adminPhone,
    'adminPassword': adminPassword
  };

}