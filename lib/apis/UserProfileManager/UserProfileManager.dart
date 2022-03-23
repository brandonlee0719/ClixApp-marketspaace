import 'package:market_space/apis/UserProfileManager/ProfileStreamer.dart';
import 'package:market_space/providers/interfaces/IProfileProvider.dart';

class  UserProfileManager{
  Map<ProfileStreamerType, ProfileStreamer> profileMap = Map<ProfileStreamerType, ProfileStreamer>();
  IProfileProvider provider = ConcreteProfileProvider();

  UserProfileManager(){
    for(ProfileStreamerType value in ProfileStreamerType.values){
      ProfileStreamer streamer = ProfileStreamer(value)..fetchData(provider);
      profileMap[value] =  streamer;
    }
  }
  
  Stream<String> getStream(ProfileStreamerType type){
    return profileMap[type].getStream();
  }

  void reload(ProfileStreamerType type){
    profileMap[type].fetchData(provider);
  }
}