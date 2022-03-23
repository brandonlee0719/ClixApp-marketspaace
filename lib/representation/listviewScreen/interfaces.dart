import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:market_space/apis/firebaseManager.dart';

// model interface
class IJsonDecodeModel {
  //interface no need to return actual data
  // ignore: missing_return
  static IJsonDecodeModel fromJson(Map<String, dynamic> map) {}
}

class IListScreenProvider<T extends Object> {
  // ignore: missing_return
  Future<List<T>> getList() {}
}

class IWidgetDisplayer<T extends Object> {
  // ignore: missing_return
  Widget render(T document) {}
}

class IQueryDecorator {
  Future<Query> decorate(CollectionReference ref) {}
}

class TransactionDecorator implements IQueryDecorator {
  @override
  Future<Query> decorate(CollectionReference ref) async {
    // TODO: implement decorate
    return ref.orderBy("createdAt");
  }
}

class OnTheWayDecorator implements IQueryDecorator {
  @override
  Future<Query> decorate(CollectionReference ref) async {
    String UID = FirebaseManager.instance.getUID();

    return ref.where('buyerUID', isEqualTo: UID).where('shippingStatus',
        whereIn: [
          'AWAITING SHIPPING',
          'shipped'.toUpperCase()
        ]).orderBy("timeStamp", descending: true);
  }
}

class RecentBuyDecorator implements IQueryDecorator {
  final bool isBuy;

  RecentBuyDecorator(this.isBuy);
  @override
  Future<Query> decorate(CollectionReference ref) async {
    String uId = FirebaseManager.instance.getUID();

    return ref
        .where(isBuy ? 'buyerUID' : 'sellerUID', isEqualTo: uId)
        .orderBy("timeStamp", descending: true);
  }
}

class InterestEarningDecorator implements IQueryDecorator {
  @override
  Future<Query> decorate(CollectionReference ref) async {
    return ref.orderBy("timeStamp", descending: true);
  }
}

class FireBasePaginateProvider
    implements IListScreenProvider<QueryDocumentSnapshot> {
  CollectionReference ref;
  Query query;

  final IQueryDecorator decorator;
  int limit = 3;
  int loadMoreLimit = 8;
  QueryDocumentSnapshot snap;

  FireBasePaginateProvider(this.ref, this.decorator);

  @override
  Future<List<QueryDocumentSnapshot>> getList({bool pagi = false}) async {
    // print("loading");
    // print(ref.path);
    List<QueryDocumentSnapshot> documentList;
    if (!pagi) {
      query = await decorator.decorate(ref);
      try {
        documentList = (await query.limit(limit).get()).docs;
      } catch (e) {
        // print(e);
      }
      // print(documentList);
    } else {
      documentList =
          (await query.startAfterDocument(snap).limit(loadMoreLimit).get())
              .docs;
    }
    if (documentList.isNotEmpty) {
      snap = documentList.last;
    }

    return documentList;
  }
}
