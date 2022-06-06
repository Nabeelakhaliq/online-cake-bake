import 'package:flutter/material.dart';
import 'package:online_cake_ordering/widgets/common_widgets.dart';

class CustomerOrderDetails extends StatefulWidget {
  const CustomerOrderDetails({Key? key}) : super(key: key);

  @override
  _CustomerOrderDetailsState createState() => _CustomerOrderDetailsState();
}

class _CustomerOrderDetailsState extends State<CustomerOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Order Details"),
    );
  }
}
