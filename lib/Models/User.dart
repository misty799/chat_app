class User{
  String email;
  String name;
  String userId;
  String photopath;
  User({this.email,this.name,this.userId,this.photopath});
  
  User.fromMap(Map<String, dynamic> map) {
    this.userId=map["userId"];
    this.email = map["email"];
    this.name=map["name"];
    this.photopath=map["photopath"];
  }
  
  toJson(String userId) {
    return {
      "userId":userId,
      "email": this.email,
      "photoPath":this.photopath,
      "name": this.name,};}
}