import 'package:market_space/providers/interfaces/IProfileProvider.dart';
import 'package:rxdart/rxdart.dart';

enum ProfileStreamerType{
  Liked,
  OnTheWay,
  Earnings,
  Revenue,

}

class ProfileStreamer{
  final ProfileStreamerType type;
  // ignore: close_sinks
  BehaviorSubject<String> _sink = BehaviorSubject<String>();

  ProfileStreamer(this.type);

  Stream<String> getStream(){
    return _sink.stream;
  }

  _addToSink(String s){
    _sink.add(s);
  }

  Future<void> fetchData(IProfileProvider provider) async {
    String s;
    switch(type){
      case ProfileStreamerType.Earnings:{
        s = await provider.getEarnings();
        break;
      }

      case ProfileStreamerType.Liked:{
        s = await provider.getLiked();
        break;
      }

      case ProfileStreamerType.OnTheWay:{
        s = await provider.getItemOnTheWay();
        break;
      }

      case ProfileStreamerType.Revenue:{
        s = await provider.getSalesRevenue();
        break;
      }

    }
    _addToSink(s);
  }
}

