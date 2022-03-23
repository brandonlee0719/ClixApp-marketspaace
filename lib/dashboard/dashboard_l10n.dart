import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  flashPromo,
  messages,
  wallet,
  profile,
  search,
  preloved,
  international,
  digital,
  local,
  electronics,
  fashion,
  DIY,
  Toys,
  More,
  categories,
  books,
  Films,
  Games,
  Art,
  Software,
  Music,
  Beauty,
  homeGrd,
  sportGood,
  Others,
  womensFashion,
  mensFashion,
  herAccessories,
  hisAccessories,
  technology,
  office,
  sports,
  homeandKitchen,

  estimatedAmount,
  digitalProduct,
  productKey,
  deliveryInfo,
  certificationText,
  productVariation,
  quantity,
  and,
  storeCondition,
  discount,
  priceWhenDicAvailable,
  Subcategories,
  Fiction,
  NonFiction,
//  office,
  os,
  CDs,
  records,
  menClothing,
  womenClothing,
  womenShoes,
  menShoes,
  menAccessories,
  womenBags,
  womenAccessories,
  eyewear,
  maleFrag,
  womenFrag,
  unisexFrag,
  parts,
  Accessories,
  Cables,
  Laptops,
  Desktop,
  mobile,
  kitchenElectronics,
  consumer,
  homeEnter,
  gamingConsole,
  condition,
  brandNew,
  Preloved,
  Select,
  ElectricalSupplies,
  DoorHardware,
  Garage,
  HomeBuildingHardware,
  FlooringTiles,
  CabinetsCountertopsHardware,
  EquipmentTools,
  Furniture,
  Crafts,
  BuildingMaterials,
  Decor,
  BuildingToys,
  ActionFigures,
  TVMovieCharacterToys,
  Collectables,
  OutdoorToys,
  Puzzles,
  DollsTeddyBears,
  CyclingEquipment,
  FitnessRunningYogaEquipment,
  CampingHikingEquipment,
  GolfEquipmentGear,
  FishingEquipmentSupplies,
  HuntingEquipment,
  SportsTradingCardsAccessories,
  Boating,
  SurfingEquipment,
  AFLEquipment,
  MartialArtsEquipment,
  HorseRidingEquipment,
  SkateboardingEquipment,
  SoccerEquipment,
  NRLEquipment,
  SkiingSnowboardingEquipment,
  HandlingTime,
  Instant,
  hour,
  confirm,
  Books,
  Mobile,
  Computer,
  Camera,
  Gaming,
  MobileAccessories,
  ComputerAccessories,
  CarAccessories,
  Watches,
  Tops,
  Jackets,
  Hoodies,
  Formal,
  Work,
  Sportwear,
  Swimwear,
  Underwear,
  Sleepwear,
  Jeans,
  Boots,
  Sneakers,
  Bottoms,
  Dresses,
  ElegantDresses,
  Flats,
  Heels,
  Sandals,
  Shorts,
  Kitchenware,
  Bath,
  Bedding,
  Dining,
  Storage,
  Outdoor,
  Laundry,
  Handbags,
  Purses,
  Jewellery,
  Hats,
  Belts,
  Sunglasses,
  Ties,
  Wallets,
  Chair,
  Desk,
  Shoes,
  Equipment,
  Clothing,
  main
}

class DashboardL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.main: "Main",
      _LKeys.messages: "Messages",
      _LKeys.profile: "Profile",
      _LKeys.wallet: "Wallet",
      _LKeys.search: "Search",
      _LKeys.flashPromo: "Flash Promo",
      _LKeys.preloved: "Preloved",
      _LKeys.digital: "Digital",
      _LKeys.international: "International",
      _LKeys.local: "Local",
      _LKeys.electronics: "Electronics",
      _LKeys.fashion: "Fashion",
      _LKeys.DIY: "DIY",
      _LKeys.Toys: "Toys",
      _LKeys.More: "More",
      _LKeys.categories: "Categories",
      _LKeys.books: "Books",
      _LKeys.Films: "Films",
      _LKeys.Games: "Games",
      _LKeys.Art: "Art",
      _LKeys.Software: "Software",
      _LKeys.Music: "Music",
      _LKeys.Beauty: "Beauty",
      _LKeys.homeGrd: "Home & Garder",
      _LKeys.sportGood: "Sporting goods",
      _LKeys.Others: "Others",
      _LKeys.estimatedAmount: "Estimated Amount",
      _LKeys.digitalProduct: "Digital product",
      _LKeys.productKey: "Product key",
      _LKeys.deliveryInfo: "Delivery Information",
      _LKeys.certificationText:
          "I certify that I am the owner of the product license.",
      _LKeys.productVariation: "Products variations",
      _LKeys.quantity: "quantity",
      _LKeys.and: "and",
      _LKeys.storeCondition: "Store conditions",
      _LKeys.discount: "discount",
      _LKeys.priceWhenDicAvailable: "Price when discount available",
      _LKeys.Subcategories: "Subcategories",
      _LKeys.Fiction: "Fiction",
      _LKeys.NonFiction: "NonFiction",
      _LKeys.office: "Office & Business",
      _LKeys.os: "Operating systems",
      _LKeys.CDs: "CDs",
      _LKeys.records: "Vinyl Records",
      _LKeys.menClothing: "Men’s Clothing",
      _LKeys.womenClothing: "Women’s Clothing",
      _LKeys.womenShoes: "Women’s Shoes",
      _LKeys.menShoes: "Men’s Shoes",
      _LKeys.menAccessories: "Men’s Accessories",
      _LKeys.womenBags: "Women’s Bags & Handbags",
      _LKeys.womenAccessories: "Women’s Accessories",
      _LKeys.eyewear: "Eyewear",
      _LKeys.maleFrag: "Male fragrances",
      _LKeys.womenFrag: "Women’s fragrances",
      _LKeys.unisexFrag: "Unisex fragrances",
      _LKeys.parts: "Parts",
      _LKeys.Accessories: "Accessories",
      _LKeys.Cables: "Cables",
      _LKeys.Laptops: "Laptops",
      _LKeys.Desktop: "Desktop PCs",
      _LKeys.mobile: "Mobile Phones",
      _LKeys.kitchenElectronics: "Kitchen Electronics",
      _LKeys.consumer: "Consumer Electronics",
      _LKeys.homeEnter: "Home Entertainment",
      _LKeys.gamingConsole: "Gaming consoles",
      _LKeys.condition: "Condition",
      _LKeys.brandNew: "Brand New",
      _LKeys.Preloved: "Preloved",
      _LKeys.Select: "Select",
      _LKeys.ElectricalSupplies: "ElectricalSupplies",
      _LKeys.DoorHardware: "DoorHardware",
      _LKeys.Garage: "Garage",
      _LKeys.HomeBuildingHardware: "HomeBuildingHardware",
      _LKeys.FlooringTiles: "FlooringTiles",
      _LKeys.CabinetsCountertopsHardware: "CabinetsCountertopsHardware",
      _LKeys.EquipmentTools: "EquipmentTools",
      _LKeys.Furniture: "Furniture",
      _LKeys.Crafts: "Crafts",
      _LKeys.BuildingMaterials: "BuildingMaterials",
      _LKeys.Decor: "Decor",
      _LKeys.BuildingToys: "BuildingToys",
      _LKeys.ActionFigures: "ActionFigures",
      _LKeys.TVMovieCharacterToys: "TVMovieCharacterToys",
      _LKeys.Collectables: "Collectables",
      _LKeys.OutdoorToys: "OutdoorToys",
      _LKeys.Puzzles: "Puzzles",
      _LKeys.DollsTeddyBears: "DollsTeddyBears",
      _LKeys.CyclingEquipment: "CyclingEquipment",
      _LKeys.FitnessRunningYogaEquipment: "FitnessRunningYogaEquipment",
      _LKeys.CampingHikingEquipment: "CampingHikingEquipment",
      _LKeys.GolfEquipmentGear: "GolfEquipmentGear",
      _LKeys.FishingEquipmentSupplies: "FishingEquipmentSupplies",
      _LKeys.HuntingEquipment: "HuntingEquipment",
      _LKeys.SportsTradingCardsAccessories: "SportsTradingCardsAccessories",
      _LKeys.Boating: "Boating",
      _LKeys.SurfingEquipment: "SurfingEquipment",
      _LKeys.AFLEquipment: "AFLEquipment",
      _LKeys.MartialArtsEquipment: "MartialArtsEquipment",
      _LKeys.HorseRidingEquipment: "Horse Riding Equipment",
      _LKeys.SkateboardingEquipment: "Skateboarding Equipment",
      _LKeys.SoccerEquipment: "Soccer Equipment",
      _LKeys.NRLEquipment: "NRL Equipment",
      _LKeys.SkiingSnowboardingEquipment: "Skiing & Snowboarding Equipment",
      _LKeys.HandlingTime: "Handling time",
      _LKeys.Instant: "Instant",
      _LKeys.hour: "hr",
      _LKeys.confirm: "CONFIRM",
      _LKeys.Books: "Books",
      _LKeys.womensFashion: "Women's Fashion",
      _LKeys.mensFashion: "Men's Fashion",
      _LKeys.herAccessories: "Her Accessories",
      _LKeys.hisAccessories: "His Accessories",
      _LKeys.technology: "Technology",
      _LKeys.office: "Office",
      _LKeys.sports: "Sports",
      _LKeys.homeandKitchen: "Home & Kitchen",
      _LKeys.Mobile: "Mobile",
      _LKeys.Computer: "Computer",
      _LKeys.Camera: "Comp\nAccs",
      _LKeys.Gaming: "Gaming",
      _LKeys.MobileAccessories: "Mobile\nAccs",
      _LKeys.ComputerAccessories: "Camera",
      _LKeys.CarAccessories: "Car Accs",
      _LKeys.Watches: "Watches",
      _LKeys.Boots: "Boots",
      _LKeys.Tops: "Tops",
      _LKeys.Jackets: "Jackets",
      _LKeys.Hoodies: "Hoodies",
      _LKeys.Formal: "Formal",
      _LKeys.Work: "Work",
      _LKeys.Sportwear: "Sports\nwear",
      _LKeys.Swimwear: "Swim\nwear",
      _LKeys.Underwear: "Under\nwear",
      _LKeys.Sleepwear: "Sleep\nwear",
      _LKeys.Jeans: "Jeans",
      _LKeys.Sneakers: "Sneakers",
      _LKeys.Bottoms: "Bottoms",
      _LKeys.Dresses: "Dresses",
      _LKeys.ElegantDresses: "Elegant\nDresses",
      _LKeys.Flats: "Flats",
      _LKeys.Heels: "Heels",
      _LKeys.Sandals: "Sandals",
      _LKeys.Shorts: "Shorts",
      _LKeys.Kitchenware: "Kitchen\nware",
      _LKeys.Bath: "Bath",
      _LKeys.Bedding: "Bedding",
      _LKeys.Dining: "Dining",
      _LKeys.Outdoor: "Outdoor",
      _LKeys.Storage: "Storage",
      _LKeys.Laundry: "Laundry",
      _LKeys.Handbags: "Hand\nbags",
      _LKeys.Purses: "Purses",
      _LKeys.Jewellery: "Jewellery",
      _LKeys.Hats: "Hats",
      _LKeys.Belts: "Belts",
      _LKeys.Sunglasses: "Sun\nglasses",
      _LKeys.Ties: "Ties",
      _LKeys.Wallets: "Wallets",
      _LKeys.Chair: "Chair",
      _LKeys.Desk: "Desk",
      _LKeys.Clothing: "Clothing",
      _LKeys.Shoes: "Shoes",
      _LKeys.Equipment: "Equipment",
    },
    L10nService.ptZh.toString(): {
      _LKeys.main: "主要的",
      _LKeys.Books: "图书",
      _LKeys.messages: "留言内容",
      _LKeys.profile: "个人资料",
      _LKeys.wallet: "钱包",
      _LKeys.search: "搜索",
      _LKeys.flashPromo: "Flash促销",
      _LKeys.preloved: "喜爱",
      _LKeys.digital: "数字",
      _LKeys.international: "国际的",
      _LKeys.local: "本地",
      _LKeys.electronics: "电子产品",
      _LKeys.fashion: "时尚",
      _LKeys.DIY: "自己动手做",
      _LKeys.Toys: "玩具",
      _LKeys.More: "更多",
      _LKeys.categories: "分类目录",
      _LKeys.books: "图书",
      _LKeys.Films: "电影",
      _LKeys.Games: "游戏类",
      _LKeys.Art: "艺术",
      _LKeys.Software: "软件",
      _LKeys.Music: "音乐",
      _LKeys.Beauty: "美人",
      _LKeys.homeGrd: "家居与园艺",
      _LKeys.sportGood: "体育用品",
      _LKeys.Others: "其他",
      _LKeys.estimatedAmount: "估计金额",
      _LKeys.digitalProduct: "数码产品",
      _LKeys.productKey: "产品密钥",
      _LKeys.deliveryInfo: "配送信息",
      _LKeys.certificationText: "我证明我是产品许可证的所有者。",
      _LKeys.productVariation: "产品变化",
      _LKeys.quantity: "数量",
      _LKeys.and: "和",
      _LKeys.storeCondition: "存放条件",
      _LKeys.discount: "折扣",
      _LKeys.priceWhenDicAvailable: "有折扣时的价格",
      _LKeys.Subcategories: "子类别",
      _LKeys.Fiction: "小说",
      _LKeys.NonFiction: "非小说类",
      _LKeys.office: "办公室与商务",
      _LKeys.os: "操作系统",
      _LKeys.CDs: "光盘",
      _LKeys.records: "黑胶唱片",
      _LKeys.menClothing: "男士服装",
      _LKeys.womenClothing: "女性着装",
      _LKeys.womenShoes: "女鞋",
      _LKeys.menShoes: "女鞋",
      _LKeys.menAccessories: "男士配饰",
      _LKeys.womenBags: "女士手袋",
      _LKeys.womenAccessories: "女士配饰",
      _LKeys.eyewear: "眼镜",
      _LKeys.maleFrag: "男性香水",
      _LKeys.womenFrag: "女士香水",
      _LKeys.unisexFrag: "中性香水",
      _LKeys.parts: "部分",
      _LKeys.Accessories: "附件",
      _LKeys.Cables: "电缆",
      _LKeys.Laptops: "笔记本电脑",
      _LKeys.Desktop: "台式电脑",
      _LKeys.mobile: "手提电话",
      _LKeys.kitchenElectronics: "厨房电子",
      _LKeys.consumer: "消费类电子产品",
      _LKeys.homeEnter: "家庭娱乐",
      _LKeys.gamingConsole: "游戏机",
      _LKeys.condition: "健康）状况",
      _LKeys.brandNew: "全新的",
      _LKeys.Preloved: "喜爱",
      _LKeys.Select: "选择",
      _LKeys.ElectricalSupplies: "电器用品",
      _LKeys.DoorHardware: "门五金",
      _LKeys.Garage: "车库",
      _LKeys.HomeBuildingHardware: "房屋建筑五金",
      _LKeys.FlooringTiles: "地板砖",
      _LKeys.CabinetsCountertopsHardware: "橱柜，台面和五金",
      _LKeys.EquipmentTools: "设备与工具",
      _LKeys.Furniture: "家具类",
      _LKeys.Crafts: "工艺",
      _LKeys.BuildingMaterials: "建筑材料",
      _LKeys.Decor: "装潢",
      _LKeys.BuildingToys: "建筑玩具",
      _LKeys.ActionFigures: "动作人物",
      _LKeys.TVMovieCharacterToys: "电视电影角色玩具",
      _LKeys.Collectables: "收藏品",
      _LKeys.OutdoorToys: "户外玩具",
      _LKeys.Puzzles: "谜题",
      _LKeys.DollsTeddyBears: "洋娃娃和泰迪熊",
      _LKeys.CyclingEquipment: "单车装备",
      _LKeys.FitnessRunningYogaEquipment: "健身，跑步和瑜伽设备",
      _LKeys.CampingHikingEquipment: "露营装备",
      _LKeys.GolfEquipmentGear: "高尔夫装备及装备",
      _LKeys.FishingEquipmentSupplies: "捕鱼设备及用品",
      _LKeys.HuntingEquipment: "狩猎装备",
      _LKeys.SportsTradingCardsAccessories: "体育交易卡及配件",
      _LKeys.Boating: "划船",
      _LKeys.SurfingEquipment: "冲浪装备",
      _LKeys.AFLEquipment: "AFLE设备",
      _LKeys.MartialArtsEquipment: "武术装备",
      _LKeys.HorseRidingEquipment: "骑马装备",
      _LKeys.SkateboardingEquipment: "滑板设备",
      _LKeys.SoccerEquipment: "足球装备",
      _LKeys.NRLEquipment: "NRL设备",
      _LKeys.SkiingSnowboardingEquipment: "滑雪和单板滑雪设备",
      _LKeys.HandlingTime: "处理时间",
      _LKeys.Instant: "瞬间",
      _LKeys.hour: "小时",
      _LKeys.confirm: "确认",
      _LKeys.womensFashion: "女装时尚",
      _LKeys.mensFashion: "男士时装",
      _LKeys.herAccessories: "她的配件",
      _LKeys.hisAccessories: "他的配件",
      _LKeys.technology: "技术",
      _LKeys.sports: "运动的",
      _LKeys.homeandKitchen: "家庭和厨房",
      _LKeys.Mobile: "移动的",
      _LKeys.Computer: "计算机",
      _LKeys.Camera: "相机",
      _LKeys.Gaming: "赌博",
      _LKeys.MobileAccessories: "移动配件",
      _LKeys.ComputerAccessories: "电脑配件",
      _LKeys.CarAccessories: "汽车配件",
      _LKeys.Watches: "手表",
      _LKeys.Boots: "靴子",
      _LKeys.Tops: "上衣",
      _LKeys.Jackets: "夹克",
      _LKeys.Hoodies: "头巾",
      _LKeys.Formal: "正式的",
      _LKeys.Work: "工作",
      _LKeys.Sportwear: "运动服",
      _LKeys.Swimwear: "游泳衣",
      _LKeys.Underwear: "内衣",
      _LKeys.Sleepwear: "睡衣",
      _LKeys.Jeans: "牛仔裤",
      _LKeys.Sneakers: "运动鞋",
      _LKeys.Bottoms: "底部",
      _LKeys.Dresses: "礼服",
      _LKeys.ElegantDresses: "优雅礼服",
      _LKeys.Flats: "公寓",
      _LKeys.Heels: "高跟鞋",
      _LKeys.Sandals: "凉鞋",
      _LKeys.Shorts: "短裤",
      _LKeys.Kitchenware: "厨具",
      _LKeys.Bath: "浴",
      _LKeys.Bedding: "寝具",
      _LKeys.Dining: "用餐",
      _LKeys.Outdoor: "户外",
      _LKeys.Storage: "贮存",
      _LKeys.Laundry: "洗衣店",
      _LKeys.Handbags: "手袋",
      _LKeys.Purses: "皮包",
      _LKeys.Jewellery: "首饰",
      _LKeys.Hats: "帽子",
      _LKeys.Belts: "皮带",
      _LKeys.Sunglasses: "太阳镜",
      _LKeys.Ties: "领带",
      _LKeys.Wallets: "皮夹",
      _LKeys.Chair: "椅子",
      _LKeys.Desk: "桌子",
      _LKeys.Clothing: "服装",
      _LKeys.Shoes: "鞋",
      _LKeys.Equipment: "设备",
    },
  };

  String get main => _localizedValues[locale.toString()][_LKeys.main];

  String get Clothing => _localizedValues[locale.toString()][_LKeys.Clothing];

  String get Shoes => _localizedValues[locale.toString()][_LKeys.Shoes];

  String get Equipment => _localizedValues[locale.toString()][_LKeys.Equipment];

  String get Chair => _localizedValues[locale.toString()][_LKeys.Chair];
  String get Desk => _localizedValues[locale.toString()][_LKeys.Desk];

  String get Handbags => _localizedValues[locale.toString()][_LKeys.Handbags];
  String get Purses => _localizedValues[locale.toString()][_LKeys.Purses];
  String get Jewellery => _localizedValues[locale.toString()][_LKeys.Jewellery];
  String get Hats => _localizedValues[locale.toString()][_LKeys.Hats];
  String get Belts => _localizedValues[locale.toString()][_LKeys.Belts];
  String get Sunglasses =>
      _localizedValues[locale.toString()][_LKeys.Sunglasses];
  String get Ties => _localizedValues[locale.toString()][_LKeys.Ties];
  String get Wallets => _localizedValues[locale.toString()][_LKeys.Wallets];

  String get Kitchenware =>
      _localizedValues[locale.toString()][_LKeys.Kitchenware];
  String get Bath => _localizedValues[locale.toString()][_LKeys.Bath];
  String get Bedding => _localizedValues[locale.toString()][_LKeys.Bedding];
  String get Dining => _localizedValues[locale.toString()][_LKeys.Dining];
  String get Furniture => _localizedValues[locale.toString()][_LKeys.Furniture];
  String get Outdoor => _localizedValues[locale.toString()][_LKeys.Outdoor];
  String get Storage => _localizedValues[locale.toString()][_LKeys.Storage];
  String get Laundry => _localizedValues[locale.toString()][_LKeys.Laundry];

  String get Bottoms => _localizedValues[locale.toString()][_LKeys.Bottoms];
  String get Dresses => _localizedValues[locale.toString()][_LKeys.Dresses];
  String get ElegantDresses =>
      _localizedValues[locale.toString()][_LKeys.ElegantDresses];
  String get Flats => _localizedValues[locale.toString()][_LKeys.Flats];
  String get Heels => _localizedValues[locale.toString()][_LKeys.Heels];
  String get Sandals => _localizedValues[locale.toString()][_LKeys.Sandals];
  String get Shorts => _localizedValues[locale.toString()][_LKeys.Shorts];

  String get Boots => _localizedValues[locale.toString()][_LKeys.Boots];
  String get Tops => _localizedValues[locale.toString()][_LKeys.Tops];
  String get Jackets => _localizedValues[locale.toString()][_LKeys.Jackets];
  String get Hoodies => _localizedValues[locale.toString()][_LKeys.Hoodies];
  String get Formal => _localizedValues[locale.toString()][_LKeys.Formal];
  String get Work => _localizedValues[locale.toString()][_LKeys.Work];
  String get Sportwear => _localizedValues[locale.toString()][_LKeys.Sportwear];
  String get Swimwear => _localizedValues[locale.toString()][_LKeys.Swimwear];
  String get Underwear => _localizedValues[locale.toString()][_LKeys.Underwear];
  String get Sleepwear => _localizedValues[locale.toString()][_LKeys.Sleepwear];
  String get Jeans => _localizedValues[locale.toString()][_LKeys.Jeans];
  String get Sneakers => _localizedValues[locale.toString()][_LKeys.Sneakers];

  String get Mobile => _localizedValues[locale.toString()][_LKeys.Mobile];
  String get Computer => _localizedValues[locale.toString()][_LKeys.Computer];
  String get Camera => _localizedValues[locale.toString()][_LKeys.Camera];
  String get Gaming => _localizedValues[locale.toString()][_LKeys.Gaming];
  String get MobileAccessories =>
      _localizedValues[locale.toString()][_LKeys.MobileAccessories];
  String get ComputerAccessories =>
      _localizedValues[locale.toString()][_LKeys.ComputerAccessories];
  String get CarAccessories =>
      _localizedValues[locale.toString()][_LKeys.CarAccessories];
  String get Watches => _localizedValues[locale.toString()][_LKeys.Watches];

  String get womensFashion =>
      _localizedValues[locale.toString()][_LKeys.womensFashion];
  String get mensFashion =>
      _localizedValues[locale.toString()][_LKeys.mensFashion];
  String get herAccesssories =>
      _localizedValues[locale.toString()][_LKeys.herAccessories];
  String get hisAccessories =>
      _localizedValues[locale.toString()][_LKeys.hisAccessories];
  String get technology =>
      _localizedValues[locale.toString()][_LKeys.technology];
  String get office => _localizedValues[locale.toString()][_LKeys.office];
  String get sports => _localizedValues[locale.toString()][_LKeys.sports];
  String get homeandKitchen =>
      _localizedValues[locale.toString()][_LKeys.homeandKitchen];

  String get messages => _localizedValues[locale.toString()][_LKeys.messages];
  String get profile => _localizedValues[locale.toString()][_LKeys.profile];
  String get wallet => _localizedValues[locale.toString()][_LKeys.wallet];
  String get search => _localizedValues[locale.toString()][_LKeys.search];
  String get flashPromo =>
      _localizedValues[locale.toString()][_LKeys.flashPromo];
  String get preloved => _localizedValues[locale.toString()][_LKeys.preloved];
  String get international =>
      _localizedValues[locale.toString()][_LKeys.international];
  String get digital => _localizedValues[locale.toString()][_LKeys.digital];
  String get local => _localizedValues[locale.toString()][_LKeys.local];
  String get electronics =>
      _localizedValues[locale.toString()][_LKeys.electronics];
  String get fashion => _localizedValues[locale.toString()][_LKeys.fashion];
  String get DIY => _localizedValues[locale.toString()][_LKeys.DIY];
  String get Toys => _localizedValues[locale.toString()][_LKeys.Toys];
  String get More => _localizedValues[locale.toString()][_LKeys.More];
  String get categories =>
      _localizedValues[locale.toString()][_LKeys.categories];
  String get books => _localizedValues[locale.toString()][_LKeys.books];
  String get Films => _localizedValues[locale.toString()][_LKeys.Films];
  String get Games => _localizedValues[locale.toString()][_LKeys.Games];
  String get Art => _localizedValues[locale.toString()][_LKeys.Art];
  String get Software => _localizedValues[locale.toString()][_LKeys.Software];
  String get Music => _localizedValues[locale.toString()][_LKeys.Music];
  String get Beauty => _localizedValues[locale.toString()][_LKeys.Beauty];
  String get homeGrd => _localizedValues[locale.toString()][_LKeys.homeGrd];
  String get sportGood => _localizedValues[locale.toString()][_LKeys.sportGood];
  String get Others => _localizedValues[locale.toString()][_LKeys.Others];

  String get Books => _localizedValues[locale.toString()][_LKeys.Books];

  String get HorseRidingEquipment =>
      _localizedValues[locale.toString()][_LKeys.HorseRidingEquipment];
  String get SkateboardingEquipment =>
      _localizedValues[locale.toString()][_LKeys.SkateboardingEquipment];
  String get SoccerEquipment =>
      _localizedValues[locale.toString()][_LKeys.SoccerEquipment];
  String get NRLEquipment =>
      _localizedValues[locale.toString()][_LKeys.NRLEquipment];
  String get SkiingSnowboardingEquipment =>
      _localizedValues[locale.toString()][_LKeys.SkiingSnowboardingEquipment];
  String get HandlingTime =>
      _localizedValues[locale.toString()][_LKeys.HandlingTime];
  String get Instant => _localizedValues[locale.toString()][_LKeys.Instant];
  String get hour => _localizedValues[locale.toString()][_LKeys.hour];
  String get confirm => _localizedValues[locale.toString()][_LKeys.confirm];

  String get condition => _localizedValues[locale.toString()][_LKeys.condition];

  String get gamingConsole =>
      _localizedValues[locale.toString()][_LKeys.gamingConsole];

  String get homeEnter => _localizedValues[locale.toString()][_LKeys.homeEnter];

  String get consumer => _localizedValues[locale.toString()][_LKeys.consumer];

  String get kitchenElectronics =>
      _localizedValues[locale.toString()][_LKeys.kitchenElectronics];

  String get parts => _localizedValues[locale.toString()][_LKeys.parts];

  String get Cables => _localizedValues[locale.toString()][_LKeys.Cables];

  String get Laptops => _localizedValues[locale.toString()][_LKeys.Laptops];

  String get Desktop => _localizedValues[locale.toString()][_LKeys.Desktop];

  String get mobile => _localizedValues[locale.toString()][_LKeys.mobile];

  String get Accessories =>
      _localizedValues[locale.toString()][_LKeys.Accessories];

//  String get office => _localizedValues[locale.toString()][_LKeys.office];

  String get Subcategories =>
      _localizedValues[locale.toString()][_LKeys.Subcategories];

  String get Fiction => _localizedValues[locale.toString()][_LKeys.Fiction];

  String get NonFiction =>
      _localizedValues[locale.toString()][_LKeys.NonFiction];

  String get os => _localizedValues[locale.toString()][_LKeys.os];

  String get CDs => _localizedValues[locale.toString()][_LKeys.CDs];

  String get records => _localizedValues[locale.toString()][_LKeys.records];

  String get menClothing =>
      _localizedValues[locale.toString()][_LKeys.menClothing];

  String get womenClothing =>
      _localizedValues[locale.toString()][_LKeys.womenClothing];

  String get menShoes => _localizedValues[locale.toString()][_LKeys.menShoes];

  String get menAccessories =>
      _localizedValues[locale.toString()][_LKeys.menAccessories];

  String get womenBags => _localizedValues[locale.toString()][_LKeys.womenBags];

  String get womenAccessories =>
      _localizedValues[locale.toString()][_LKeys.womenAccessories];

  String get eyewear => _localizedValues[locale.toString()][_LKeys.eyewear];

  String get maleFrag => _localizedValues[locale.toString()][_LKeys.maleFrag];

  String get womenFrag => _localizedValues[locale.toString()][_LKeys.womenFrag];

  String get unisexFrag =>
      _localizedValues[locale.toString()][_LKeys.unisexFrag];

  String get brandNew => _localizedValues[locale.toString()][_LKeys.brandNew];

  String get Preloved => _localizedValues[locale.toString()][_LKeys.Preloved];

  String get select => _localizedValues[locale.toString()][_LKeys.Select];

  String get electricalSupplies =>
      _localizedValues[locale.toString()][_LKeys.ElectricalSupplies];

  String get doorHardware =>
      _localizedValues[locale.toString()][_LKeys.DoorHardware];

  String get garage => _localizedValues[locale.toString()][_LKeys.Garage];

  String get homeBuildingHardware =>
      _localizedValues[locale.toString()][_LKeys.HomeBuildingHardware];

  String get FlooringTiles =>
      _localizedValues[locale.toString()][_LKeys.FlooringTiles];

  String get CabinetsCountertopsHardware =>
      _localizedValues[locale.toString()][_LKeys.CabinetsCountertopsHardware];

  String get EquipmentTools =>
      _localizedValues[locale.toString()][_LKeys.EquipmentTools];

  String get Crafts => _localizedValues[locale.toString()][_LKeys.Crafts];

  String get BuildingMaterials =>
      _localizedValues[locale.toString()][_LKeys.BuildingMaterials];

  String get Decor => _localizedValues[locale.toString()][_LKeys.Decor];

  String get BuildingToys =>
      _localizedValues[locale.toString()][_LKeys.BuildingToys];

  String get ActionFigures =>
      _localizedValues[locale.toString()][_LKeys.ActionFigures];

  String get TVMovieCharacterToys =>
      _localizedValues[locale.toString()][_LKeys.TVMovieCharacterToys];

  String get Collectables =>
      _localizedValues[locale.toString()][_LKeys.Collectables];

  String get OutdoorToys =>
      _localizedValues[locale.toString()][_LKeys.OutdoorToys];

  String get Puzzles => _localizedValues[locale.toString()][_LKeys.Puzzles];

  String get DollsTeddyBears =>
      _localizedValues[locale.toString()][_LKeys.DollsTeddyBears];

  String get CyclingEquipment =>
      _localizedValues[locale.toString()][_LKeys.CyclingEquipment];

  String get FitnessRunningYogaEquipment =>
      _localizedValues[locale.toString()][_LKeys.FitnessRunningYogaEquipment];

  String get CampingHikingEquipment =>
      _localizedValues[locale.toString()][_LKeys.CampingHikingEquipment];

  String get GolfEquipmentGear =>
      _localizedValues[locale.toString()][_LKeys.GolfEquipmentGear];

  String get FishingEquipmentSupplies =>
      _localizedValues[locale.toString()][_LKeys.FishingEquipmentSupplies];

  String get HuntingEquipment =>
      _localizedValues[locale.toString()][_LKeys.HuntingEquipment];

  String get SportsTradingCardsAccessories =>
      _localizedValues[locale.toString()][_LKeys.SportsTradingCardsAccessories];

  String get Boating => _localizedValues[locale.toString()][_LKeys.Boating];

  String get SurfingEquipment =>
      _localizedValues[locale.toString()][_LKeys.SurfingEquipment];

  String get AFLEquipment =>
      _localizedValues[locale.toString()][_LKeys.AFLEquipment];

  String get MartialArtsEquipment =>
      _localizedValues[locale.toString()][_LKeys.MartialArtsEquipment];

  String get discount => _localizedValues[locale.toString()][_LKeys.discount];

  String get quantity => _localizedValues[locale.toString()][_LKeys.quantity];

  String get productVariation =>
      _localizedValues[locale.toString()][_LKeys.productVariation];

  String get and => _localizedValues[locale.toString()][_LKeys.and];

  String get priceWhenDicAvailable =>
      _localizedValues[locale.toString()][_LKeys.priceWhenDicAvailable];

  String get estimatedAmount =>
      _localizedValues[locale.toString()][_LKeys.estimatedAmount];

  String get digitalProduct =>
      _localizedValues[locale.toString()][_LKeys.digitalProduct];

  String get productKey =>
      _localizedValues[locale.toString()][_LKeys.productKey];

  String get deliveryInfo =>
      _localizedValues[locale.toString()][_LKeys.deliveryInfo];

  String get certificationText =>
      _localizedValues[locale.toString()][_LKeys.certificationText];

  String get storeCondition =>
      _localizedValues[locale.toString()][_LKeys.storeCondition];

  final Locale locale;

  DashboardL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate = _LogInL10nDelegate();
}

class _LogInL10nDelegate extends AL10nDelegate<DashboardL10n> {
  const _LogInL10nDelegate();

  @override
  Future<DashboardL10n> load(Locale locale) =>
      SynchronousFuture<DashboardL10n>(DashboardL10n(locale));
}
