import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';

/// A custom [TextFormField] widget that can be used to input text with validation.

class TextFormFieldWidget extends StatelessWidget {
  /// Creates a new instance of [TextFormFieldWidget].
  ///
  /// * [textController] - A [TextEditingController] to display the text the user enters
  /// * [label] - A [String] to show as the label for the text field.
  /// * [hint] - A [String] to show as the hint for the text field.
  /// * [onChanged] - An optional callback function that might be needed in some textfields to display something in the same page
  /// * [maxlines]  - an optional maxlines of type [int]
  /// * [maxLength] - an optional maxlength of type [int]
  /// * [isPrefixIconrequired] -an optional [bool] to check if a prefix icon is required for that field
  /// * [prefixIcon]  - an optional prefix icon
  /// * [isSuffixRequired] - to check if the field is required or not to display a red (*)
  /// * [enabled] - optional enabled to check if the textfield will be enabled or not
  /// *[onEditingComplete] -optional callback function to be called when we want to do something when user finish editing the field

  const TextFormFieldWidget({
    Key? key,
    required TextEditingController textController,
    String? label,
    String? hint,
    required bool? isSuffixRequired,
    String? initialValue,
    int? maxLength,
    int? maxlines,
    bool? isPrefixIconrequired,
    Icon? prefixIcon,
    bool? enabled,
    bool? isHidden,
    this.onChanged,
    this.onEditingComplete,
    required this.fontSize,
    this.fillColor,
  })  : _textController = textController,
        _label = label,
        _hint = hint,
        _isSuffixRequired = isSuffixRequired,
        _maxLength = maxLength,
        _maxlines = maxlines,
        _initialValue = initialValue,
        _isPrefixIconRequired = isPrefixIconrequired,
        _PrefixIcon = prefixIcon,
        _enabled = enabled,
        _isHidden = isHidden,
        super(key: key);

  final TextEditingController _textController;
  final String? _label;
  final String? _hint;
  final bool? _isSuffixRequired;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final int? _maxLength;
  final int? _maxlines;
  final String? _initialValue;
  final bool? _isPrefixIconRequired;
  final Icon? _PrefixIcon;
  final bool? _enabled;
  final bool? _isHidden;
  final double fontSize;
  final Color? fillColor;

  @override
  Key? get key => super.key;

  @override
  Widget build(BuildContext context) {
    /// Returns a [TextFormField] widget wrapped in [Padding] widget with a set of attributes such as [maxLength], [decoration], [validator].
    ///
    /// [_isRequired] boolean is used to show error message if the field is empty and required.
    ///

    return Padding(
      key: key,
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        autofocus: true,
        enabled: _enabled,
        controller: _textController,
        maxLength: _maxLength,
        initialValue: _initialValue,
        obscureText: _isHidden!,
        decoration: InputDecoration(
          labelText: _label,
          labelStyle: TextStyle(
            fontSize: fontSize,
            fontFamily: GoogleFonts.montserrat().fontFamily,
            fontWeight: FontWeight.bold,
            color: HapisColors.lgColor1,
          ),
          hintText: _hint,
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
          // contentPadding:
          //     const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
          filled: true,
          fillColor: fillColor ?? Color.fromARGB(156, 240, 240, 240),
          suffixIcon: _isSuffixRequired!
              ? const Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 24),
                )
              : null,
          prefixIcon: _isPrefixIconRequired ?? false ? _PrefixIcon : null,
        ),
        onChanged: onChanged,
        style: TextStyle(
          color: Colors.black,
          fontFamily: GoogleFonts.montserrat().fontFamily,
          fontSize: fontSize,
        ),
        onEditingComplete: onEditingComplete,
        validator: (value) {
          if (_isSuffixRequired == true) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          }
        },
      ),
    );
  }
}
