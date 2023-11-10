RUST_FILE = ../rust/sideswap_client/src/ffi.rs
C_FILE = gen/side_swap_client_ffi.h
DART_FILE = ../lib/side_swap_client_ffi.dart

PROTO_FILE = sideswap.proto
DART_PROTO_DIR = ../thirdparty/sideswap_protobuf/lib/src
DART_PROTO_FILE = $(DART_PROTO_DIR)/sideswap.pb.dart

ALL: $(DART_FILE) $(DART_PROTO_FILE) # RUST_BUILD

$(C_FILE): $(RUST_FILE)
	rm -f $(C_FILE)
	cbindgen $(RUST_FILE) --lang c --output $(C_FILE)

$(DART_FILE): $(C_FILE)
	flutter pub run ffigen

$(DART_PROTO_FILE): $(PROTO_FILE)
	mkdir -p $(DART_PROTO_DIR)
	protoc --dart_out=$(DART_PROTO_DIR) $(PROTO_FILE)

RUST_BUILD:
	touch ../rust/sideswap_client/build.rs
	cd ../rust; cargo build --workspace --exclude sideswap_client_test --exclude sideswap_dealer_example
