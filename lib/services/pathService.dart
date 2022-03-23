import 'package:cloud_firestore/cloud_firestore.dart';

// for universal path in firebase, in order to reuse the firebase path, I made a pathService enum
// and this is able to call different firebase path according to the path enum we call, so we can
// update, add delete,
enum PathService{
  userPath,
  conversationUnsentPath,
}

extension PathGetter on PathService{
  CollectionReference getPath(){
    switch(this){
      case PathService.userPath:
        return FirebaseFirestore.instance.collection('users');
      case PathService.conversationUnsentPath:
        return FirebaseFirestore.instance.collection('channels').doc('chatChannel').collection('unsentMessages');
      default:
        return null;
    }

  }
}