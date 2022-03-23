class UserDetail{
  String id;
  String name;
  String imgUrl;
  String description;


  UserDetail(this.name, this.imgUrl, this.description);

  static UserDetail fromJson(Map<String, dynamic> mp){
    return UserDetail(mp["displayName"], mp["profilePictureURL"], mp["bio"]);
  }
}