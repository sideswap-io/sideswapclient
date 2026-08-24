import 'dart:collection';
import 'dart:typed_data';

import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:sideswap/common/network/pegx_channel_factory.dart';

class PegxConnection {
  final Future<WebSocketChannel> Function(String url) _channelFactory;

  WebSocketChannel? _channel;
  bool _isConnected = false;
  final _sendBuffer = Queue<Uint8List>();

  PegxConnection({
    Future<WebSocketChannel> Function(String url)? channelFactory,
  }) : _channelFactory = channelFactory ?? defaultPegxChannelFactory;

  bool get isConnected => _isConnected;
  Stream<dynamic>? get stream => _channel?.stream;

  Future<void> connect(String url) async {
    if (_isConnected) return;
    _channel = await _channelFactory(url);
    _isConnected = true;
    // NOTE: drainBuffer() is NOT called here — caller invokes it after setting up stream listener
  }

  void send(Uint8List data) {
    if (_isConnected) {
      _channel?.sink.add(data);
    } else {
      _sendBuffer.add(data);
    }
  }

  void close() {
    if (!_isConnected) return;
    _channel?.sink.close(status.normalClosure);
    _isConnected = false;
  }

  /// Flush buffered messages to sink. Call after setting up stream listener.
  void drainBuffer() {
    while (_sendBuffer.isNotEmpty) {
      _channel?.sink.add(_sendBuffer.removeFirst());
    }
  }
}
