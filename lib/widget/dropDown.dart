import 'package:flutter/material.dart';

class DropDown extends StatelessWidget {
  const DropDown({Key? key, 
    this.value,
    this.text,
    this.list,
    this.item,
    this.onChanged,
    this.validateText,
  }) : super(key: key);
  final value, text, list, item, onChanged, validateText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(5),
      //   // border: Border.all(color: Colors.amber),
      // ),

      child: DropdownButtonFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null) {
            return validateText;
          }
          return null;
        },

        isExpanded: true,
        value: value,
        // underline: ,
        hint: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
        items: list.map<DropdownMenuItem<Object>>(item).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class DropItem {
  static DropdownMenuItem<Object> item({name, value}) {
    return DropdownMenuItem(
        child: Container(
          child: Text(
            name,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        value: value);
  }
}
