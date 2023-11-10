dart pub global activate protoc_plugin

dart pub get
dart pub run ffigen:setup -I/usr/lib/llvm-10/include -L/usr/lib/llvm-10/lib

sudo port install clang-10
dart pub run ffigen:setup -I/opt/local/libexec/llvm-10/include -L/opt/local/libexec/llvm-10/lib

# Protoc-dart plugin

# https://github.com/dart-lang/protobuf/tree/master/protoc_plugin

protoc --dart_out=. pegx_api.proto
protoc --dart_out=. sideswap.proto
