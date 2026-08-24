import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel> defaultPegxChannelFactory(String url) async {
  final channel = IOWebSocketChannel.connect(
    url,
    pingInterval: const Duration(seconds: 10),
  );
  await channel.ready;
  return channel;
}
