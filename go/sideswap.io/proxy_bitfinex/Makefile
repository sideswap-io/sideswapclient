PROTO_FILE = proto/bitfinex.proto
GO_PROTO_FILE = proto/bitfinex.pb.go

export PATH := $(HOME)/go/bin:$(PATH)

ALL: gen-proto linux windows

gen-proto:
	protoc --go_out=./../.. proto/bitfinex.proto

linux:
	go build -buildmode c-archive -o libproxy_bitfinex_linux.a

windows:
	CC=x86_64-w64-mingw32-gcc CGO_ENABLED=1 GOOS=windows go build -buildmode c-archive -o libproxy_bitfinex_windows.a
