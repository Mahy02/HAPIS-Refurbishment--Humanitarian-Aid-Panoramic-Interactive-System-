import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/drop_down_state.dart';
import '../utils/build_drop_menu_items.dart';

/// A custom [DropDownListWidget]  that displays a dropdown list with provided [items]
///
/// The dropdown widget is built using [DropdownButtonFormField] and is wrapped in a [Consumer] widget that listens to changes in the [DropdownState] object.
///
/// The selected item is determined by the [selectedIndex] property of the [DropdownState] object.
///
/// The selected item is managed by a [DropdownState] instance.
///
/// The items in the dropdown list are generated from the `items` list provided to the widget.
///
///we have: * [items] : A list of items to be displayed in the dropdown list.
///         * [prefixIcon] : An optional icon to be displayed as a prefix in the input field.
///         * [selectedValue] : the currently selected item in the dropdown list
///         * [hinttext] :for hints
///         * [onChanged] : A callback function that will be called whenever the selected item changes.

class DropDownListWidget extends StatelessWidget {
  /// A list of items to be displayed in the dropdown list.
  final List<String> items;

  /// An optional icon to be displayed as a prefix in the input field.
  final Widget? prefixIcon;

  /// The currently selected item in the dropdown list.
  final String? selectedValue;

  ///For hint text"
  final String? hinttext;

  final double fontSize;

  /// A callback function that will be called whenever the selected item changes.
  final void Function(String)? onChanged;

  /// Creates a new instance of [DropDownListWidget].
  /// The [items] parameter is required.
  const DropDownListWidget({
    Key? key,
    required this.items,
    this.prefixIcon,
    this.selectedValue,
    this.hinttext,
    this.onChanged,
    required this.fontSize,
  }) : super(key: key);

  @override
  Key? get key => super.key;

  @override
  Widget build(BuildContext context) {
    return Consumer<DropdownState>(
      key: key,
      builder: (BuildContext context, state, Widget? child) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 5.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: HapisColors.lgColor3,
                width: 2.0,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
            prefixIcon: prefixIcon,
            hintText: hinttext,
            fillColor:
                const Color.fromARGB(156, 240, 240, 240), // set fill color
            filled: true,
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: HapisColors.lgColor3,
            size: 36,
          ),
          items: items.map((String item) {
            return buildMenuItem(item, fontSize);
          }).toList(),
          value: selectedValue ?? items[0],
          onChanged: (value) {
            int index = state.selectedIndex = items.indexOf(value!);
            int length = items.length;
            onChanged?.call(value);
          },
          style: TextStyle(fontSize: fontSize, color: Colors.black),
        ),
      ),
    );
  }
}
