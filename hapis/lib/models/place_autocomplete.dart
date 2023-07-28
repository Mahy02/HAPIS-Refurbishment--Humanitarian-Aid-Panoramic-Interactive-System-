import 'dart:convert';
import 'auto_complete_prediction.dart';


class PlaceAutoCompleteResponse{
    final String? status;
    final List<AutocompletePrediction>? predictions;


PlaceAutoCompleteResponse({this.status, this.predictions});


factory PlaceAutoCompleteResponse.fromJson(Map<String, dynamic> json){
    return PlaceAutoCompleteResponse(
        status: json['status'] as String?,
        // ignore: prefer_null_aware_operators
        predictions: json['predictions'] !=null 
        ? json['predictions']
        .map<AutocompletePrediction>(
            (json) => AutocompletePrediction.fromJson(json))
            .toList()
        : null,
    );
}

static PlaceAutoCompleteResponse parseAutocompleteResult( String responseBody){
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceAutoCompleteResponse.fromJson(parsed);
}

}