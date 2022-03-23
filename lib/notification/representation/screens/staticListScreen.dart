import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/notification/logics/factories/StaticTileFactory.dart';
import 'package:market_space/notification/models/commonQuestionModel.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';


class StaticListViewModel{
  final List<dynamic> list;

  StaticListViewModel(this.list);
}

class StaticListScreen extends StatelessWidget {
  // List<HelpModel> helps = [
  //   HelpModel("Buyer/Seller queries"),
  //   HelpModel("Postage queries"),
  //   HelpModel("Returns and refunds queries"),
  //   HelpModel("Wallet queries"),
  // ];
  final StaticListViewModel model;

  const StaticListScreen({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar: Toolbar(
        title: 'MARKETSPAACE',
      ),
      body: Column(
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier*70,
            child: ListView.builder(
              itemCount: model.list.length,
              itemBuilder: (context,index){
                return StaticTileFactory.instance.build(model.list[index]);
              }),
          ),
          Container(
            padding: EdgeInsets.all(SizeConfig.widthMultiplier*5),
            child: ButtonBuilder().build(ButtonSection(ButtonSectionType.blueButton, "contact our professor for help",
                (){
                  RouterService.appRouter.navigateTo(
                      '/dashboard/messageChat?isCreating=true&uid=${Constants.adminUid}&name=admin');
                })),
          )
        ],
      ),

    );
  }
}


mixin QABuilder{
  // this is a valid name!
  // ignore: non_constant_identifier_names
  List<QuestionModel> BSSectionList=[
    QuestionModel(
        'How to contact seller / buyer?',
        'From the profile page, either click your order, if you see it under the ‘Recently Bought’ section, orclick ‘SEE ALL’, then click on the item and select ‘MORE OPTIONS.’ '
        'From this page if you scroll down you will see a button that says ‘CONTACT BUYER’ or ‘CONTACT SELLER’.'
    ),
    QuestionModel(
        'How to fill up the delivery address?',
        'The delivery address can be added either at checkout or by clicking on the settings icon on the profile page, '
        'going to the ‘Address’ section and clicking the ‘Add new address’ button. '
    ),
    QuestionModel(
        'How about if I forgot my password? ',
        'You can easily reset your password from the login screen.'
    ),
    QuestionModel(
        'Can I pay / receive bitcoin if I do not have bitcoin account?',
        'Yes, you can definitely pay by credit card and obtain bitcoin. All Market Spaace accounts have a bitcoin wallet created on signup and therefore, you can receive bitcoin instantly.'
    ),
    QuestionModel(
        'Can I pay / receive bitcoin if I do not have bitcoin account?',
        'Yes, you can definitely pay by credit card and obtain bitcoin. All Market Spaace accounts have a bitcoin wallet created on signup and therefore, you can receive bitcoin instantly.'
    ),
    QuestionModel(
        'How much will charge by MS for every purchase?',
        'Purchases by crypto are free! Purchase by credit card currently incur a surcharge. The surcharge is 3.4% of the purchase or \$5 USD (whichever is greater). We are working towards lowering this fee.  '
    ),
    QuestionModel(
        'Will that be safe to pay online in MS? What will happen if I did not receive the product after payment?',
        'All of your funds are held in our escrow service, and is not release to the seller until either you have confirmed you’ve received the item or the purchase protection time has expired (which is 29 days). Until one of those events has occurred, we can refund the payment back to you. '
    ),
    QuestionModel(
        'How come after I paid for the product, the seller said he/she did not able to receive the payment?',
        'If the order successfully completed, the funds will be held in Market Spaace escrow for 29 days or until the buyer has confirmed they’ve received the item. It is likely that the funds are held in our escrow and the seller is unaware. '
        'The seller can check their held funds by going to the ‘Wallet’ page,clicking on the currency they set to receive payment, and checking the ‘Held funds’ label. If the seller '
        'has received a notification that they have sold an item, payment is definitely successful and the seller can process the item.'
    ),
    QuestionModel(
      ' How long will it take to receive the money once the product is sold? (Seller)',
      'After 29 days. You can receive the money earlier, if the buyer confirms they have received the item. If the buyer confirms they have received the item, the money will be released instantaneously. '
    ),
  ];

  List<QuestionModel> refundSectionList=[
    QuestionModel('How to refund the product if I am not satisfied with the quality? How long will it take to refund?',
        'Refunds on Market Spaace are easy. Select the item from your recently bought items in the profile page (click ‘SEE ALL’ if you don’t see it there, then click on the item and select ‘MORE OPTIONS’). If the order hasn’t '
        'shipped, you can raise a cancellation request, scroll down and fill out the cancellation form, if the cancellation request is accepted, you will receive a refund. If the order has shipped or the cancellation request was declined by the other party, '
        'you can raise a claim.Underneath the cancel order section, '
        'you should see a section called ‘Raise a claim’, fill out the details, and an admin will step in to handle the case shortly after.  you can select the item from your orders and raise a claim.'
        ' We highly suggest you attempt to work it out with the seller first though, before raising a claim. '),
    QuestionModel('How long will it take to refund?', 'If you paid by credit card, the time it takes to credit back to your bank account depends on your '
    'bank. Typically, this can take about 1-2 weeks depending on the bank. If the order had to be handled'
    'by the admin to process the refund, the time it takes to sort out the case is separate from the time'
    'your bank takes to refund the amount.  '),
    QuestionModel('Who will be paying for the shipping fee if the product need to be refund (buyer or seller)? ',
        'This depends on the reason. If the return was due to a change of mind, the buyer will need to pay for the shipping. '
        'If the product was faulty or poor quality, the seller will need to pay for the shipping.'),
    QuestionModel('Can I still apply for refund after I pay? (Buyer)',
        'Absolutely, you are able to apply to raise a claim up to 29 days after order or apply for a cancellation'
        ' request to be approved by the seller if the item hasn’t already shipped. '),
    QuestionModel('How long will it take till I am able to receive my refund? (Buyer) ',
      'For most items, both a buyer and seller can apply for a refund at any point as long as the item has not shipped yet. After it has shipped, an admin will need to step in, the duration for how long a case '
      'lasts, is dependent on how long mediation lasts, but should typically take 1 week. After the week, '
      'the bank will take another 1-2 weeks to refund the purchase to your card.'),
  ];
  
  List<QuestionModel> shippingList=[
    QuestionModel('How come the product need to add shipping fee after I purchase?',
        'Some products do not have the shipping fee included in the purchase, other products have free '
        'shipping, for the products that do not have free shipping, the shipping fee needs to be paid.'),
    QuestionModel('How long will it take to ship locally / oversea?',
        'Shipping time varies depending on the seller and their location. The shipping time estimates for'
        'each product can be found in the description when a product is selected. '),
    QuestionModel('How much will it cost to ship locally / oversea?',
        'Shipping time varies depending on the seller and their location. The shipping time estimates for'
        'each product can be found in the description when a product is selected.'),
    QuestionModel('Can I combine a several products and ship it to together in once (same buyer / difference buyer)?',
        'Yes, you can buy several products at once, if you purchase from multiple sellers, each item will be '
        'posted by their respective seller, therefore you may receive your order in multiple packages.'),
    QuestionModel(' How to track my shipping? ',
        'Clicking on your item from the Profile Page, will give you a general status of your order. '
        'If the item is yet to be shipped, if the item has been shipped, or if the order has completed. The seller may'
        'attach the tracking number to your order too, you can copy this tracking number and track it on the'
        'courier’s website.'),
    QuestionModel('How to contact shipping company?',
        'The seller will supply the courier of your package. Search this shipping company in your search'
        'engine and contact details for the company should be available.'),
    QuestionModel('What should I do if the product(s) is/are broken/less, when I receive it?',
        ' Please contact the seller first and try to work out the issue. If you are unable to work it out, please '
        'raise a claim. You can do this by selecting the item from the ‘Recently Bought’ section in your profile '
        'screen, then select \'MORE OPTIONS\' or if you have already been redirected to this page, scroll down '
        'and click ‘RAISE CLAIM’.'),
    QuestionModel('Can I request my preference shipping company? ',
        'The item can only be shipped by the shipment methods the seller has provided.'),
  ];

  List<QuestionModel> investmentScreenList=[
    QuestionModel('How to exchange crypto to bank account?',
        'If you would like to withdraw the money to your bank account, from the wallet page click on the '
        'centre button in the middle of the bottom app bar. After that, click ‘Sell’, you can now follow the '
        'onscreen prompts to withdraw to your bank account.'),
    QuestionModel('How about someone stole my bitcoin in my wallet? ', 
        'Our funds are secured by our payment provider Wyre.'),
    QuestionModel('Can anyone else access my account? If my mobile got stolen?',
        'All transactions require phone biometrics (or pin whichever is setup) before they can perform any '
        'monetary functions. '),
    QuestionModel('Can I transfer my bitcoin in my wallet to the other user? ',
        'If you would like to withdraw to another crypto wallet, click on the asset from the wallet page, '
        'click ‘Withdraw’, and then follow the onscreen prompts to withdraw to an external wallet.'),
    QuestionModel('What is the daily limit for transection? Can I set my daily limit?',
        'There are daily limits for credit card transactions. Weekly: \$1000, Monthly: \$4000, Yearly: \$7500.'
        'You can increase these limits by following the onscreen prompts to verify your ID.'),
    QuestionModel(' Can I merge my other wallet into MS wallet?',
        'At this time, you are unable to connect an external wallet to Market Spaace.'),
    QuestionModel('Can I exchange my wallet’s money / credit for product?',
        'Yes absolutely, this is one of the functions of the application. '),
    QuestionModel('How many cryptocurrencies does MS support?',
        'Market Spaace currently supports Bitcoin, Ethereum and USDC.')
];

  void pushShipping(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return StaticListScreen(model: StaticListViewModel(shippingList));
        }));
  }
  void pushBS(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return StaticListScreen(model: StaticListViewModel(BSSectionList));
        }));
    // return StaticListScreen(model: StaticListViewModel(BSSectionList),);
  }
  void pushRefund(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return StaticListScreen(model: StaticListViewModel(refundSectionList));
        }));
  }
  void pushInvestment(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return StaticListScreen(model: StaticListViewModel(investmentScreenList));
        }));
  }

}

class QAScreen extends StatefulWidget {
  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> with QABuilder {

  List<HelpModel> getHelps(){

    return[
      HelpModel("Buyer/Seller queries",
          onClick: (){pushBS(context);}),
      HelpModel("Postage queries",onClick: (){pushShipping(context);}),
      HelpModel("Returns and refunds queries",onClick: (){pushRefund(context);}),
      HelpModel("Wallet queries",onClick: (){pushInvestment(context);}),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return StaticListScreen(model: StaticListViewModel(getHelps()),);
  }
}

