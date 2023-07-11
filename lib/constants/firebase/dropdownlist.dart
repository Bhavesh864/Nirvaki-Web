class Dropdownlist {
  List<Dropdown>? dropdown;

  Dropdownlist({this.dropdown});

  Dropdownlist.fromJson(Map<String, dynamic> json) {
    if (json["dropdown"] is List) {
      dropdown = json["dropdown"] == null
          ? null
          : (json["dropdown"] as List)
              .map((e) => Dropdown.fromJson(e))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dropdown != null) {
      data["dropdown"] = dropdown?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Dropdown {
  String? roomconfig;
  List<String>? values;

  Dropdown({this.roomconfig, this.values});

  Dropdown.fromJson(Map<String, dynamic> json) {
    if (json["roomconfig"] is String) {
      roomconfig = json["roomconfig"];
    }
    if (json["values"] is List) {
      values =
          json["values"] == null ? null : List<String>.from(json["values"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["roomconfig"] = roomconfig;
    if (values != null) {
      data["values"] = values;
    }
    return data;
  }
}
