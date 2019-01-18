import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {
  final String address;

  AddressTag(this.address);

  @override
  Widget build(BuildContext context) {
    if (this.address != null && this.address.isNotEmpty)
      return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(5.0)),
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
          child: Text(address));
    else
      return Container();
  }
}
