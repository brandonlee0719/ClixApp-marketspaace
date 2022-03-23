import 'package:flutter/material.dart';
import 'package:market_space/common/colors.dart';

class Message extends StatelessWidget {
  Message({this.msg, this.direction, this.dateTime});

  final String msg;
  final String direction;
  final String dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: direction == 'left'
          ? Container(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        //for left corner
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/seller_img.png',
                              fit: BoxFit.scaleDown,
                              width: 30.0,
                              height: 30.0,
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 6.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.text_back_blue,
                                    border: Border.all(
                                        color: AppColors.text_back_blue,
                                        width: .25,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(5.0),
                                      bottomRight: Radius.circular(0.0),
                                      bottomLeft: Radius.circular(0.0),
                                    ),
                                  ),
                                  alignment: Alignment.bottomLeft,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    msg,
                                    style: TextStyle(
                                      fontFamily: 'Gamja Flower',
                                      fontSize: 20.0,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 6.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.text_back_blue,
                                    border: Border.all(
                                        color: AppColors.text_back_blue,
                                        width: .25,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(0.0),
                                      topLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(5.0),
                                    ),
                                  ),
                                  alignment: Alignment.bottomLeft,
                                  padding: const EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 8.0,
                                      left: 8.0,
                                      right: 8.0),
                                  child: Text(
                                    dateTime,
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )

                    //date time
                  ],
                ),
              ],
            ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        //for right corner
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 6.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.text_back,
                                    border: Border.all(
                                        color: AppColors.text_back,
                                        width: .25,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5.0),
                                      topLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(0.0),
                                      bottomLeft: Radius.circular(0.0),
                                    ),
                                  ),
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    msg,
                                    style: TextStyle(
                                      fontFamily: 'Gamja Flower',
                                      fontSize: 20.0,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                                //date time
                                Container(
                                  margin: EdgeInsets.only(right: 6.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.text_back,
                                    border: Border.all(
                                        color: AppColors.text_back,
                                        width: .25,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(0.0),
                                      topLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(10.0),
                                    ),
                                  ),
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 8.0,
                                      left: 8.0,
                                      right: 8.0),
                                  child: Text(
                                    dateTime,
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                              ],
                            ),
                            Image.asset(
                              'assets/images/profile_pic.png',
                              fit: BoxFit.scaleDown,
                              width: 30.0,
                              height: 30.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
