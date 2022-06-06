
class AddressModel {

  late String fullName;
  late String phoneNumber;
  late String provinceName;
  late String cityName;
  late String deliveryAddress;
  late String addressType;
  late bool isDefaultShippingAddress;

  AddressModel(this.fullName, this.phoneNumber, this.provinceName, this.cityName, this.deliveryAddress, this.addressType, this.isDefaultShippingAddress);

  AddressModel.fromJson(Map<dynamic, dynamic> json)
      : fullName = json['fullName'] as String,
        phoneNumber = json['phoneNumber'] as String,
        provinceName = json['provinceName'] as String,
        cityName = json['cityName'] as String,
        deliveryAddress = json['deliveryAddress'] as String,
        addressType = json['addressType'] as String,
        isDefaultShippingAddress = json['isDefaultShippingAddress'] as bool;

  static AddressModel? fromMap(Map value) {
    if (value == null) {
      return null;
    }

    return AddressModel(
      value['fullName'],
      value['phoneNumber'],
      value['provinceName'],
      value['cityName'],
      value['deliveryAddress'],
      value['addressType'],
      value['isDefaultShippingAddress'],
    );
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'provinceName': provinceName,
    'cityName': cityName,
    'deliveryAddress': deliveryAddress,
    'addressType': addressType,
    'isDefaultShippingAddress': isDefaultShippingAddress
  };

}