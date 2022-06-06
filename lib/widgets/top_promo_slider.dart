import 'package:flutter/material.dart';
import 'package:image_slider/image_slider.dart';
import 'package:online_cake_ordering/config/size_config.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';

class TopPromoSlider extends StatefulWidget {

  const TopPromoSlider(this.height, this.width, this.imagesList, {Key? key}) : super(key: key);
  final double height, width;
  final List<String> imagesList;

  @override
  _TopPromoSliderState createState() => _TopPromoSliderState();
}

class _TopPromoSliderState extends State<TopPromoSlider> with SingleTickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.imagesList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ImageSlider(
        tabIndicatorSelectedColor: AppColors.kPrimaryColor,
        tabIndicatorHeight: 12.0,
        tabIndicatorSize: 12.0,
        curve: Curves.fastOutSlowIn,
        duration: const Duration(seconds: 5),
        showTabIndicator: true,
        allowManualSlide: true,
        autoSlide: true,
        width: SizeConfig.screenWidth,
        height: 200,
        tabController: tabController,
        children: widget.imagesList.map((String imageUrl) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              imageUrl,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.fill,
            ),
          );
        }).toList()
    );
  }
}