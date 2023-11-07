class ChatRoom {
  String? roomId;
  String? roomType;
  String? roomName;
  List<Participants>? participants;
  String? createdBy;
  String? createdOn;

  ChatRoom({this.roomId, this.roomType, this.roomName, this.participants, this.createdBy, this.createdOn});

  ChatRoom.fromJson(Map<String, dynamic> json) {
    if (json["roomId"] is String) {
      roomId = json["roomId"];
    }
    if (json["roomType"] is String) {
      roomType = json["roomType"];
    }
    if (json["roomName"] is String) {
      roomName = json["roomName"];
    }
    if (json["participants"] is List) {
      participants = json["participants"] == null ? null : (json["participants"] as List).map((e) => Participants.fromJson(e)).toList();
    }
    if (json["createdBy"] is String) {
      createdBy = json["createdBy"];
    }
    if (json["createdOn"] is String) {
      createdOn = json["createdOn"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["roomId"] = roomId;
    data["roomType"] = roomType;
    data["roomName"] = roomName;
    if (participants != null) {
      data["participants"] = participants?.map((e) => e.toJson()).toList();
    }
    data["createdBy"] = createdBy;
    data["createdOn"] = createdOn;
    return data;
  }
}

class Participants {
  String? userId;
  String? joinedOn;
  String? lastSeen;

  Participants({this.userId, this.joinedOn, this.lastSeen});

  Participants.fromJson(Map<String, dynamic> json) {
    if (json["userId"] is String) {
      userId = json["userId"];
    }
    if (json["joinedOn"] is String) {
      joinedOn = json["joinedOn"];
    }
    if (json["lastSeen"] is String) {
      lastSeen = json["lastSeen"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["userId"] = userId;
    data["joinedOn"] = joinedOn;
    data["lastSeen"] = lastSeen;
    return data;
  }
}
