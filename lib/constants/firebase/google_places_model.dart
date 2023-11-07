class GooglePlaces {
  List<Predictions>? predictions;
  String? status;

  GooglePlaces({this.predictions, this.status});

  GooglePlaces.fromJson(Map<String, dynamic> json) {
    if (json["predictions"] is List) {
      predictions = json["predictions"] == null ? null : (json["predictions"] as List).map((e) => Predictions.fromJson(e)).toList();
    }
    if (json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (predictions != null) {
      data["predictions"] = predictions?.map((e) => e.toJson()).toList();
    }
    data["status"] = status;
    return data;
  }
}

class Predictions {
  String? description;
  List<MatchedSubstrings>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Terms>? terms;
  List<String>? types;

  Predictions({this.description, this.matchedSubstrings, this.placeId, this.reference, this.structuredFormatting, this.terms, this.types});

  Predictions.fromJson(Map<String, dynamic> json) {
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["matched_substrings"] is List) {
      matchedSubstrings = json["matched_substrings"] == null ? null : (json["matched_substrings"] as List).map((e) => MatchedSubstrings.fromJson(e)).toList();
    }
    if (json["place_id"] is String) {
      placeId = json["place_id"];
    }
    if (json["reference"] is String) {
      reference = json["reference"];
    }
    if (json["structured_formatting"] is Map) {
      structuredFormatting = json["structured_formatting"] == null ? null : StructuredFormatting.fromJson(json["structured_formatting"]);
    }
    if (json["terms"] is List) {
      terms = json["terms"] == null ? null : (json["terms"] as List).map((e) => Terms.fromJson(e)).toList();
    }
    if (json["types"] is List) {
      types = json["types"] == null ? null : List<String>.from(json["types"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["description"] = description;
    if (matchedSubstrings != null) {
      data["matched_substrings"] = matchedSubstrings?.map((e) => e.toJson()).toList();
    }
    data["place_id"] = placeId;
    data["reference"] = reference;
    if (structuredFormatting != null) {
      data["structured_formatting"] = structuredFormatting?.toJson();
    }
    if (terms != null) {
      data["terms"] = terms?.map((e) => e.toJson()).toList();
    }
    if (types != null) {
      data["types"] = types;
    }
    return data;
  }
}

class Terms {
  int? offset;
  String? value;

  Terms({this.offset, this.value});

  Terms.fromJson(Map<String, dynamic> json) {
    if (json["offset"] is int) {
      offset = json["offset"];
    }
    if (json["value"] is String) {
      value = json["value"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["offset"] = offset;
    data["value"] = value;
    return data;
  }
}

class StructuredFormatting {
  String? mainText;
  List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings;
  String? secondaryText;
  List<SecondaryTextMatchedSubstrings>? secondaryTextMatchedSubstrings;

  StructuredFormatting({this.mainText, this.mainTextMatchedSubstrings, this.secondaryText, this.secondaryTextMatchedSubstrings});

  StructuredFormatting.fromJson(Map<String, dynamic> json) {
    if (json["main_text"] is String) {
      mainText = json["main_text"];
    }
    if (json["main_text_matched_substrings"] is List) {
      mainTextMatchedSubstrings =
          json["main_text_matched_substrings"] == null ? null : (json["main_text_matched_substrings"] as List).map((e) => MainTextMatchedSubstrings.fromJson(e)).toList();
    }
    if (json["secondary_text"] is String) {
      secondaryText = json["secondary_text"];
    }
    if (json["secondary_text_matched_substrings"] is List) {
      secondaryTextMatchedSubstrings = json["secondary_text_matched_substrings"] == null
          ? null
          : (json["secondary_text_matched_substrings"] as List).map((e) => SecondaryTextMatchedSubstrings.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["main_text"] = mainText;
    if (mainTextMatchedSubstrings != null) {
      data["main_text_matched_substrings"] = mainTextMatchedSubstrings?.map((e) => e.toJson()).toList();
    }
    data["secondary_text"] = secondaryText;
    if (secondaryTextMatchedSubstrings != null) {
      data["secondary_text_matched_substrings"] = secondaryTextMatchedSubstrings?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class SecondaryTextMatchedSubstrings {
  int? length;
  int? offset;

  SecondaryTextMatchedSubstrings({this.length, this.offset});

  SecondaryTextMatchedSubstrings.fromJson(Map<String, dynamic> json) {
    if (json["length"] is int) {
      length = json["length"];
    }
    if (json["offset"] is int) {
      offset = json["offset"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["length"] = length;
    data["offset"] = offset;
    return data;
  }
}

class MainTextMatchedSubstrings {
  int? length;
  int? offset;

  MainTextMatchedSubstrings({this.length, this.offset});

  MainTextMatchedSubstrings.fromJson(Map<String, dynamic> json) {
    if (json["length"] is int) {
      length = json["length"];
    }
    if (json["offset"] is int) {
      offset = json["offset"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["length"] = length;
    data["offset"] = offset;
    return data;
  }
}

class MatchedSubstrings {
  int? length;
  int? offset;

  MatchedSubstrings({this.length, this.offset});

  MatchedSubstrings.fromJson(Map<String, dynamic> json) {
    if (json["length"] is int) {
      length = json["length"];
    }
    if (json["offset"] is int) {
      offset = json["offset"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["length"] = length;
    data["offset"] = offset;
    return data;
  }
}
