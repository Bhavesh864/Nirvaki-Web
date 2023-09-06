class ChatMessage {
  String? messageId;
  String? roomId;
  String? senderId;
  String? messageBody;
  String? messageType;
  String? timestamp;
  String? status;

  ChatMessage({this.messageId, this.roomId, this.senderId, this.messageBody, this.messageType, this.timestamp, this.status});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    if (json["messageId"] is String) {
      messageId = json["messageId"];
    }
    if (json["roomId"] is String) {
      roomId = json["roomId"];
    }
    if (json["senderId"] is String) {
      senderId = json["senderId"];
    }
    if (json["messageBody"] is String) {
      messageBody = json["messageBody"];
    }
    if (json["messageType"] is String) {
      messageType = json["messageType"];
    }
    if (json["timestamp"] is String) {
      timestamp = json["timestamp"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["messageId"] = messageId;
    data["roomId"] = roomId;
    data["senderId"] = senderId;
    data["messageBody"] = messageBody;
    data["messageType"] = messageType;
    data["timestamp"] = timestamp;
    data["status"] = status;
    return data;
  }
}
