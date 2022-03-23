import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/apis/conversation/chatManager.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/message_chat/logic/chat_row_cubit.dart';
import 'package:market_space/model/messages_model/message_history_model.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';
import 'package:video_player/video_player.dart';
import '../../message_chat_route.dart';

part 'viewModel/chat_view_model.dart';
part 'chat_bubble.dart';
part 'productWidget.dart';

class _UserImage extends StatelessWidget {
  final String imgUrl;
  final String placeHolder;

  _UserImage({Key key, this.imgUrl, this.placeHolder}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return (imgUrl != null && imgUrl != '' && imgUrl[0] != 'a')
        ? ClipOval(
            child: CachedNetworkImage(
            imageUrl: imgUrl,
            fit: BoxFit.fill,
            width: SizeConfig.widthMultiplier * 7.291666666666666,
            height: SizeConfig.heightMultiplier * 3.7661406025824964,
          ))
        : Image.asset(
            placeHolder,
            fit: BoxFit.fill,
            width: SizeConfig.widthMultiplier * 7.291666666666666,
            height: SizeConfig.heightMultiplier * 3.7661406025824964,
          );
  }
}

class _ChatImageWidget extends StatelessWidget {
  final imgUrl;

  const _ChatImageWidget({Key key, this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          right: SizeConfig.widthMultiplier * 1.4583333333333333),
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1.0043041606886658),
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        fit: BoxFit.fill,
        placeholder: (context, url) =>
            Lottie.asset('assets/loader/image_loading.json'),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      width: MediaQuery.of(context).size.width * 0.75,
    );
  }
}

class _UserVideoWidget extends StatefulWidget {
  final String videoUrl;

  const _UserVideoWidget({Key key, this.videoUrl}) : super(key: key);
  @override
  __UserVideoWidgetState createState() => __UserVideoWidgetState();
}

class __UserVideoWidgetState extends State<_UserVideoWidget> {
  VideoPlayerController _controller;
  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print("DJJNH");
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: Container(
        margin: EdgeInsets.only(
            right: SizeConfig.widthMultiplier * 1.4583333333333333),
        alignment: Alignment.bottomRight,
        padding:
            EdgeInsets.all(SizeConfig.heightMultiplier * 1.0043041606886658),
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
        width: MediaQuery.of(context).size.width * 0.75,
      ),
    );
  }
}

class _UserChatTextWidget extends StatelessWidget {
  final String messageText;
  final bool isMe;

  _UserChatTextWidget({Key key, this.messageText, this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _chatType type;
    _ChatViewModel model;
    if (isMe) {
      type = _chatType.messageFromMe;
    } else {
      type = _chatType.messageFromTheOther;
    }
    model = type.viewModel;

    return Container(
        constraints: BoxConstraints(maxWidth: SizeConfig.widthMultiplier * 70),
        margin: EdgeInsets.only(
            right: SizeConfig.widthMultiplier * 1.4583333333333333),
        decoration: BoxDecoration(
          color: model.backgroundColor,
          border: Border.all(
              color: model.backgroundColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(model.right),
            topLeft: Radius.circular(model.left),
            bottomRight: Radius.circular(model.right),
            bottomLeft: Radius.circular(model.left),
          ),
        ),

        // alignment: model.align,
        padding:
            EdgeInsets.all(SizeConfig.heightMultiplier * 1.0043041606886658),
        child: Text(
          messageText,
          maxLines: 50,
          style: TextStyle(
            fontFamily: 'Gamja Flower',
            fontSize: SizeConfig.textMultiplier * 2.5107604017216643,
            color: model.textColor,
          ),
        ));
  }
}
