import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';

/// A custom [TextFormField] widget that can be used to input text with validation.

class TextFormFieldWidget extends StatelessWidget {
  /// Creates a new instance of [TextFormFieldWidget].
  ///
  /// * [TitleController] - A [TextEditingController] to control the text field.
  /// * [label] - A [String] to show as the label for the text field.
  /// * [hint] - A [String] to show as the hint for the text field.
  /// * [isRequired] - A [bool] that determines whether or not the text field is required.
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
    this.onChanged,
    this.onEditingComplete,
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

  @override
  Key? get key => super.key;

  @override
  Widget build(BuildContext context) {
    /// Returns a [TextFormField] widget wrapped in [Padding] widget with a set of attributes such as [maxLength], [decoration], [validator].
    ///
    /// [_isRequired] boolean is used to show error message if the field is empty and required.
    return Padding(
      key: key,
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        autofocus: true,
        enabled: _enabled,
        controller: _textController,
        maxLength: _maxLength, //we also have maxLines
        initialValue: _initialValue,
        decoration: InputDecoration(
          // hintText: 'Be clear and descriptive.',
          hintText: _hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color: HapisColors.primary,
              width: 3.0,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          filled: true,
          fillColor: Color.fromARGB(156, 240, 240, 240),

          suffixIcon: _isSuffixRequired!
              ? const Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 24),
                )
              : null,
          prefixIcon: _isPrefixIconRequired ?? false ? _PrefixIcon : null,
        ),
        onChanged: onChanged,
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
