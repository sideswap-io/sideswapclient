import 'dart:async';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:sideswap/providers/pegx_connection.dart';

class FakeWebSocketChannel implements WebSocketChannel {
  final streamController = StreamController<Object?>();
  final sinkController = StreamController<Object?>();
  late final FakeWebSocketSink _sink = FakeWebSocketSink(sinkController);

  @override
  // ignore: avoid_annotating_with_dynamic
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<dynamic> get stream => streamController.stream;
  @override
  WebSocketSink get sink => _sink;
  @override
  Future<void> get ready => Future.value();
  @override
  String? get protocol => null;
  @override
  int? get closeCode => null;
  @override
  String? get closeReason => null;

  void pushMessage(Object? msg) => streamController.add(msg);
  void closeRemote() => streamController.close();
}

class FakeWebSocketSink extends DelegatingStreamSink<Object?>
    implements WebSocketSink {
  bool closeCalled = false;
  int? lastCloseCode;

  FakeWebSocketSink(StreamController<Object?> controller)
    : super(controller.sink);

  @override
  Future<void> close([int? closeCode, String? closeReason]) {
    closeCalled = true;
    lastCloseCode = closeCode;
    return super.close();
  }
}

void main() {
  late FakeWebSocketChannel fakeChannel;
  late List<String> factoryCallUrls;
  late PegxConnection connection;

  setUp(() {
    fakeChannel = FakeWebSocketChannel();
    factoryCallUrls = [];
    connection = PegxConnection(
      channelFactory: (url) async {
        factoryCallUrls.add(url);
        return fakeChannel;
      },
    );
  });

  group('connect', () {
    test('sets isConnected=true and calls channelFactory', () async {
      const url = 'wss://example.com/ws';
      expect(connection.isConnected, isFalse);

      await connection.connect(url);

      expect(connection.isConnected, isTrue);
      expect(factoryCallUrls, [url]);
    });

    test('does nothing when already connected', () async {
      const url = 'wss://example.com/ws';
      await connection.connect(url);
      await connection.connect(url);

      expect(factoryCallUrls.length, 1);
    });
  });

  group('send', () {
    test('adds data to sink when connected', () async {
      await connection.connect('wss://example.com/ws');

      final data = Uint8List.fromList([1, 2, 3]);
      connection.send(data);

      final received = await fakeChannel.sinkController.stream.first;
      expect(received, data);
    });

    test('buffers data when not connected', () {
      final data = Uint8List.fromList([4, 5, 6]);
      connection.send(data);

      expect(connection.isConnected, isFalse);
      // Sink should not have received anything
      expect(fakeChannel.sinkController.hasListener, isFalse);
    });
  });

  group('connect drains buffer', () {
    test('sends buffered data to sink after calling drainBuffer', () async {
      final data = Uint8List.fromList([7, 8, 9]);
      connection.send(data); // buffered — not connected yet

      await connection.connect('wss://example.com/ws');
      connection.drainBuffer();

      final received = await fakeChannel.sinkController.stream.first;
      expect(received, data);
    });
  });

  group('close', () {
    test('closes sink with normalClosure and sets isConnected=false', () async {
      await connection.connect('wss://example.com/ws');
      expect(connection.isConnected, isTrue);

      connection.close();

      expect(connection.isConnected, isFalse);
      final sink = fakeChannel.sink as FakeWebSocketSink;
      expect(sink.closeCalled, isTrue);
      expect(sink.lastCloseCode, status.normalClosure);
    });

    test('does nothing when not connected', () {
      // Should not throw, sink never touched
      expect(() => connection.close(), returnsNormally);
      final sink = fakeChannel.sink as FakeWebSocketSink;
      expect(sink.closeCalled, isFalse);
    });
  });
}
