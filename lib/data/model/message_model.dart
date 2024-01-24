class MessageModel {
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;
  MessageModel({this.text, this.dateTime, this.receiverId, this.senderId});

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['dateTime'] = dateTime;
    data['text'] = text;

    return data;
  }
}
