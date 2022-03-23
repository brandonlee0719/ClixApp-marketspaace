part of '../message_widgets.dart';

class _ChatViewModel {
  final Color backgroundColor;
  final double right;
  final double left;
  final Color textColor;
  final Alignment align;

  _ChatViewModel(
      this.backgroundColor, this.right, this.left, this.textColor, this.align);
}

enum _chatType { messageFromMe, messageFromTheOther }

extension chatModel on _chatType {
  _ChatViewModel get viewModel {
    switch (this) {
      case _chatType.messageFromMe:
        return _ChatViewModel(AppColors.text_back_blue, 10.0, 5.0,
            AppColors.white, Alignment.topRight);

      case _chatType.messageFromTheOther:
        return _ChatViewModel(
            AppColors.text_back, 5.0, 10.0, AppColors.black, Alignment.topLeft);
      default:
        return null;
    }
  }
}
