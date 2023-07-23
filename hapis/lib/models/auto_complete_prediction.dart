class AutocompletePrediction {
  /// [description] contains the human readable name for the returned result
  ///the business name
  final String? description;

  /// [structuredFormatting] provides pre formatted text that can be shown
  final StructuredFormatting? structuredFormatting;

  /// [placeID] is a textual identifier that uniquely identifies a place.
  /// to pass this identifier in placeID field of a places API request
  final String? placeID;

  /// [refernce] contains reference
  final String? reference;

  AutocompletePrediction({
    this.description,
    this.structuredFormatting,
    this.placeID,
    this.reference,
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String?,
      placeID: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
    );
  }
}

class StructuredFormatting {
  ///[mainText] contains the main text of prediction
  final String? mainText;

  ///[secondaryText] contains the secondary text of a prediction
  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}
