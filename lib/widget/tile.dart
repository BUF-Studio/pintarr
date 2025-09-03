import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? lead;
  final Widget? trail;
  final void Function()? tap;
  final Color? selectedColor, color;
  final bool selected;
  final bool bar;
  const Tile({Key? key, 
    this.title,
    this.subtitle,
    this.tap,
    this.lead,
    this.trail,
    this.selectedColor,
    this.color = Colors.white,
    this.selected = false,
    this.bar = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: ListTile(
        


        title: title,
        subtitle: subtitle,
        trailing: trail,
        leading: lead,
        selected: selected,
        contentPadding: EdgeInsets.symmetric(
          horizontal: bar?15:20,
          vertical: 5,
        ),
        onTap: tap,
        selectedTileColor: selectedColor,
      ),
    );
  }
}
