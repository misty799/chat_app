class Chat{
  String message;
  String date;
  String sendBy;
  Chat({this.message,this.date,this.sendBy});
  
  Chat.fromMap(Map<String, dynamic> map) {
    this.message=map["message"];
    this.date = map["date"];
    this.sendBy=map["sendBy"];
  }
  
  toJson() {
    return {
      "message": this.message,
      "date":this.date,
      "sendBy": this.sendBy,};}
}
