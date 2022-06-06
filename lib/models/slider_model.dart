
class SliderModel {
  late String sliderID;
  late String sliderImage;

  SliderModel(this.sliderID, this.sliderImage);

  SliderModel.fromJson(Map<dynamic, dynamic> json)
      : sliderID = json['sliderID'] as String,
        sliderImage = json['sliderImage'] as String;

  static SliderModel? fromMap(Map value) {
    if (value == null) {
      return null;
    }

    return SliderModel(
      value['sliderID'],
      value['sliderImage']
    );
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'sliderID': sliderID,
    'sliderImage': sliderImage
  };

}