class UserModel{
  String uid;
  String name;
  String _imgUrl;
  String _backgroundPictureURL;
  String bio;

  String get myBio => bio??'Hey there user! Come on, add a cool bio!';


  String get imgUrl => _imgUrl ?? 'assets/images/seller_img.png';
  String get backgroundPictureURL => _backgroundPictureURL?? 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg';

  UserModel(this.uid, this.name, this._imgUrl,this._backgroundPictureURL,{this.bio});

  static List<String> getTableMaps(){
    return ["userTable", "uid", "displayName", "profilePictureURL","backgroundPictureURL","bio"];
  }

  Map<String, dynamic> toJson(){
    return {
      "uid": uid,
      "displayName": name,
      "profilePictureURL": _imgUrl,
      "backgroundPictureURL":_backgroundPictureURL,
      "bio":bio,
    };
  }

  @override
  String toString(){
    return uid;
  }

  static UserModel fromJson(Map map){
    String imgUrl;
    String backUrl;
    if(map["profilePictureURL"] != ""){
      imgUrl = map["profilePictureURL"];
    }
    if(map["backgroundPictureURL"] != ""){
      backUrl = map["backgroundPictureURL"];
    }
    return UserModel(map["uid"], map["displayName"],imgUrl,backUrl,bio: map['bio']);
  }
}
