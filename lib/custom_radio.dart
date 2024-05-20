// custom_radio.dart

import 'package:flutter/material.dart';

class CustomRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;

  const CustomRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: value == groupValue
              ? Colors.black
              : Colors.transparent, // Dynamic border color
          width: 2.0, // Border width
        ),
        borderRadius: BorderRadius.circular(5.0), // Rounded corners
      ),
      child: Row(
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: Colors.black, // Consistent color
          ),
          Text(value.toString()),
        ],
      ),
    );
  }
}
