import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class CryptoClient {
  static CryptoClient _cryptoClient = CryptoClient._internal();

  factory CryptoClient() {
    if (_cryptoClient == null) {
      _cryptoClient = CryptoClient._internal();
    }
    return _cryptoClient;
  }

  CryptoClient._internal();

  Map<String, dynamic> map = {
    'messageType': 'subscribe',
    'marketIds': ['BTC-AUD', 'ETH-AUD'],
    'channels': ['tick', 'heartbeat']
  };

  IOWebSocketChannel _channel;

  var _socketUrl = "wss://socket.btcmarkets.net/v2";
  IOWebSocketChannel get channel => _channel;

  StreamController _btccontroller = StreamController.broadcast();
  StreamController get btccontroller => _btccontroller;
  StreamController _ethcontroller = StreamController.broadcast();
  StreamController get ethcontroller => _ethcontroller;
  String lastBTC = "Loading";
  String lastETH = "loading";

  bool isBTCExpend = false;
  bool isETHExpend = false;

  void open() {
    try {
      _channel = IOWebSocketChannel.connect(_socketUrl);

      if (_channel != null) {
        // print('Connected success');
        // _socketState = SocketState.open;

        // print('Listening');
        _channel.stream.listen((message) {
          var result = json.decode(message);
          // print(message);
          if (result["marketId"] == "ETH-AUD") {
            _ethcontroller.add(result["lastPrice"].toString());
            lastETH = result["lastPrice"].toString();
          }
          if (result["marketId"] == "BTC-AUD") {
            _btccontroller.add(result["lastPrice"].toString());
            lastBTC = result["lastPrice"].toString();
          }
        }, onError: (error, StackTrace stackTrace) {
          // print('received error $error $stackTrace');
        }, onDone: () {
          // _socketState = SocketState.close;

          //// print('onDone received');
        });
      }
    } catch (e) {
      //// print("An error occurred $e");
    }
  }

  Future<void> start() async {
    if (isETHExpend || isBTCExpend) {
      if (_channel == null) {
        open();
        joinChannels();
      }
    }
  }

  void joinChannels() {
    // print("Joining channels");
    var request = json.encode(map);

    _channel.sink.add(request);
  }

  void close() {
    if (!isBTCExpend && !isETHExpend) {
      // print("close socket");
      try {
        if (_channel != null) {
          //  // print("Closing ");
          _channel.sink.close();
          _channel = null;
        }
      } catch (e) {}
    }
  }

  void dispose() {
    close();
  }
}
