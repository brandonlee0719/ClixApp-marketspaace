import 'package:algolia/algolia.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';

class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: 'G12DUZNO30',
    apiKey: '59be02d8c04fa45ea11bafdb25a76c4a',
  );
}

class AlgoliaClient {
  int _searchInterestingIndex = 0;

  // int _searchIndex = 0;
  bool _isOnSearchIndex = false;
  static AlgoliaClient _cryptoClient = AlgoliaClient._internal();
  Query query = new Query();

  factory AlgoliaClient() {
    if (_cryptoClient == null) {
      _cryptoClient = AlgoliaClient._internal();
    }
    return _cryptoClient;
  }

  AlgoliaClient._internal();

  Future<List<FlashPromoAlgoliaObj>> searchBasic(
      List<String> interestList, int page) async {
    List<FlashPromoAlgoliaObj> result;
    if (!_isOnSearchIndex) {
      result = await query.searchInterestingCategories(
          interestList, _searchInterestingIndex);
      if (result.isEmpty) {
        // print("interested items is empty");
        _isOnSearchIndex = true;
        return searchBasic(interestList, page);
      } else {
        _searchInterestingIndex = _searchInterestingIndex + 1;
        return result;
      }
    } else {
      result = await query.search(page);
      if (result.isNotEmpty) {
        // _searchIndex = _searchIndex + 1;
        return result;
      }
    }
    return null;
  }

  void clickOn(
      {bool isLocal, bool isDigital, bool isPreloved, bool isInternational}) {
    // // print(
    //     "Clickon clicked with bool isLocal =$isLocal, bool isDigital = $isDigital, bool isPreloved = $isPreloved, bool isInternational= $isInternational");
    query.clickOn(
        isLocal: isLocal,
        isPreloved: isPreloved,
        isDigital: isDigital,
        isInternational: isInternational);

    setToZero();
    query._initQuery();
  }

  void setToZero() {
    // this._searchIndex = 0;
    this._searchInterestingIndex = 0;
    this._isOnSearchIndex = false;
    // this.query.productNumberList = [];
    this.query.searchKey = null;
  }

  Future<List<FlashPromoAlgoliaObj>> searchKey(String key, int page) async {
    query.searchKey = key;
    List<FlashPromoAlgoliaObj> result = await query.search(page);
    if (result.isNotEmpty) {
      // _searchIndex = _searchIndex + 1;
    } else {
      return null;
    }
    return result;
  }

  Future<List<FlashPromoAlgoliaObj>> searchCategory(
      {String category, String subCategory, int page}) async {
    List<FlashPromoAlgoliaObj> result =
        await query.searchCategory(page, category, subCategory);
    if (result.isEmpty) {
      return null;
    }
    // print("this is the result for category search");
    // print(result.toString());
    return result;
  }
}

// Future<List<FlashPromoAlgoliaObj>> searchWithString(String category, int page) async {
//   List<FlashPromoAlgoliaObj> result =
//         await query.search

// }

class Query {
  Algolia algolia = Application.algolia;
  AlgoliaQuery simpleQuery;
  String searchKey;
  bool _isLocal = false;
  bool _isDigital = false;
  bool _isPreLoved = false;
  bool _isInternational = false;

  // List<int> productNumberList = [];

  String _category;
  String _subCategory;

  Query({this.searchKey}) {
    _initQuery();
  }

  Future<List<FlashPromoAlgoliaObj>> searchString(
      String search, int page) async {
    _setSearchString(search);
    _initQuery();
    return _search(simpleQuery, page);
  }

  Future<List<FlashPromoAlgoliaObj>> search(int page) async {
    _category = null;
    _subCategory = null;
    _initQuery();
    return _search(simpleQuery, page);
  }

  _setSearchString(String search) {
    this.searchKey = search;
  }

  _setCategory(String category, String subCategory) {
    this._category = category;
    this._subCategory = subCategory;
  }

  Future<List<FlashPromoAlgoliaObj>> searchCategory(int page,
      [String category, String subCategory]) async {
    _setCategory(category, subCategory);
    _initQuery();
    return _search(simpleQuery, page);
  }

  Future<List<FlashPromoAlgoliaObj>> _search(
      AlgoliaQuery query, int page) async {
    List<AlgoliaObjectSnapshot> _algoliaSearch = [];
    List<FlashPromoAlgoliaObj> result = [];
    AlgoliaQuery finalQuery = query.setPage(page);
    var search1 = await finalQuery.getObjects();
    // print('Number of objects returned from algolia: ${search1.hits.length}');
    _algoliaSearch = (search1).hits;
    try {
      for (int i = 0; i < _algoliaSearch.length; i++) {
        AlgoliaObjectSnapshot snap = _algoliaSearch[i];
        FlashPromoAlgoliaObj obj = FlashPromoAlgoliaObj.fromJson(snap.data);
        // print("TAGS ==> ${obj.tags}");
        // if (!productNumberList.contains(obj.productNum)) {
        obj.size = await obj.calculateImageDimension();
        // productNumberList.add(obj.productNum);
        result.add(obj);
        // }
      }
    } catch (e, trace) {
      // print("$e $trace");
    }

    // print('RETURNING OBJECTS ${result.length}');

    return result;
  }

  Future<List<FlashPromoAlgoliaObj>> searchInterestingCategories(
      List<String> interestingList, int page) async {
    if (interestingList == null || interestingList.isEmpty) {
      return List<FlashPromoAlgoliaObj>();
    } else {
      // print("heihiehie");
      _initQuery();
      String filterString = 'category: ${interestingList[0]}';
      if (interestingList.length > 1) {
        for (int i = 1; i < interestingList.length; i++) {
          filterString = filterString + "OR category${interestingList[i]}";
        }
      }
      // print(filterString);
      simpleQuery = simpleQuery.setFacetFilter(filterString);
    }

    return _search(simpleQuery, page);
  }

  void clickOn(
      {bool isLocal, bool isDigital, bool isPreloved, bool isInternational}) {
    if (isLocal != null) {
      _isLocal = isLocal;
    }

    if (isDigital != null) {
      _isDigital = isDigital;
    }

    if (isPreloved != null) {
      _isPreLoved = isPreloved;
    }

    if (isInternational != null) {
      _isInternational = isInternational;
    }
  }

  void _initQuery() {
    if (searchKey == null) {
      simpleQuery = algolia.instance.index("simpleProductData").search(' ');
    } else {
      simpleQuery =
          algolia.instance.index("simpleProductData").search(searchKey);
    }

    if (this._category != null) {
      // print("cate is not empty");
      // print(_category);
      simpleQuery = simpleQuery.setFacetFilter("category:$_category");
    }
    if (this._subCategory != null) {
      simpleQuery = simpleQuery.setFacetFilter("subCategory:$_subCategory");
    }
    if (_isPreLoved == true) {
      simpleQuery = simpleQuery.setFacetFilter('condition: Preloved');
    }
    if (_isDigital) {
      simpleQuery = simpleQuery.setFacetFilter('productType: Digital product');
    }
    if (_isLocal == true) {
      simpleQuery = simpleQuery.setFacetFilter('country: ${Constants.country}');
    }
    if (_isInternational == true) {
      simpleQuery =
          simpleQuery.setFacetFilter('country: -${Constants.country}');
    }
    // simpleQuery = simpleQuery.setFacetFilter('country: -${Constants.country}');

    simpleQuery = simpleQuery.setHitsPerPage(20);
    simpleQuery = simpleQuery.setFacetFilter('approvalStatus:true');
    simpleQuery = simpleQuery.setNumericFilter('qtyAvail > 0');
    // simpleQuery = simpleQuery.setFacetFilter('version:full');
  }
}
