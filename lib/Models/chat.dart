import 'package:flutter_chat_app/Models/User.dart';

class Chat {
  String message;
  String date;
  String sendBy;
  Chat({this.message, this.date, this.sendBy});

  Chat.fromMap(Map<String, dynamic> map) {
    this.message = map["message"];
    this.date = map["date"];
    this.sendBy = map["sendBy"];
  }

  toJson() {
    return {
      "message": this.message,
      "date": this.date,
      "sendBy": this.sendBy,
    };
  }
}

class GroupPeople {
  String docId;
  List<String> usersID;
  List<String> groupUsers;
  GroupPeople({this.groupUsers, this.usersID});
  GroupPeople.fromMap(Map<String, dynamic> map) {
    this.docId = map["docId"];
    //this.groupName=map["groupName"];
    // this.createdDate=map["createdDate"];
    this.groupUsers = List<String>();
    for (var i = 0; i < map["groupUsers"].length; i++) {
      this.groupUsers.add((map["groupUsers"][i]));
    }
    this.usersID = List<String>();
    for (var i = 0; i < map["usersId"].length; i++) {
      this.groupUsers.add((map["usersId"][i]));
    }
  }
  toJson() {
    return {
      "groupUsers": List<String>.from(this.groupUsers),
      "usersId": List<String>.from(this.usersID)
      // "groupName":this.groupName,
      //"createdDate":this.createdDate
    };
  }
}
