// This file was autogenerated by some hot garbage in the `uniffi` crate.
// Trust me, you don't want to mess with it!

#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

// The following structs are used to implement the lowest level
// of the FFI, and thus useful to multiple uniffied crates.
// We ensure they are declared exactly once, with a header guard, UNIFFI_SHARED_H.
#ifdef UNIFFI_SHARED_H
    // We also try to prevent mixing versions of shared uniffi header structs.
    // If you add anything to the #else block, you must increment the version suffix in UNIFFI_SHARED_HEADER_V4
    #ifndef UNIFFI_SHARED_HEADER_V4
        #error Combining helper code from multiple versions of uniffi is not supported
    #endif // ndef UNIFFI_SHARED_HEADER_V4
#else
#define UNIFFI_SHARED_H
#define UNIFFI_SHARED_HEADER_V4
// ⚠️ Attention: If you change this #else block (ending in `#endif // def UNIFFI_SHARED_H`) you *must* ⚠️
// ⚠️ increment the version suffix in all instances of UNIFFI_SHARED_HEADER_V4 in this file.           ⚠️

typedef struct RustBuffer
{
    uint64_t capacity;
    uint64_t len;
    uint8_t *_Nullable data;
} RustBuffer;

typedef struct ForeignBytes
{
    int32_t len;
    const uint8_t *_Nullable data;
} ForeignBytes;

// Error definitions
typedef struct RustCallStatus {
    int8_t code;
    RustBuffer errorBuf;
} RustCallStatus;

// ⚠️ Attention: If you change this #else block (ending in `#endif // def UNIFFI_SHARED_H`) you *must* ⚠️
// ⚠️ increment the version suffix in all instances of UNIFFI_SHARED_HEADER_V4 in this file.           ⚠️
#endif // def UNIFFI_SHARED_H
#ifndef UNIFFI_FFIDEF_RUST_FUTURE_CONTINUATION_CALLBACK
#define UNIFFI_FFIDEF_RUST_FUTURE_CONTINUATION_CALLBACK
typedef void (*UniffiRustFutureContinuationCallback)(uint64_t, int8_t
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_FREE
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_FREE
typedef void (*UniffiForeignFutureFree)(uint64_t
    );

#endif
#ifndef UNIFFI_FFIDEF_CALLBACK_INTERFACE_FREE
#define UNIFFI_FFIDEF_CALLBACK_INTERFACE_FREE
typedef void (*UniffiCallbackInterfaceFree)(uint64_t
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE
#define UNIFFI_FFIDEF_FOREIGN_FUTURE
typedef struct UniffiForeignFuture {
    uint64_t handle;
    UniffiForeignFutureFree _Nonnull free;
} UniffiForeignFuture;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_U8
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_U8
typedef struct UniffiForeignFutureStructU8 {
    uint8_t returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructU8;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_U8
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_U8
typedef void (*UniffiForeignFutureCompleteU8)(uint64_t, UniffiForeignFutureStructU8
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_I8
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_I8
typedef struct UniffiForeignFutureStructI8 {
    int8_t returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructI8;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_I8
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_I8
typedef void (*UniffiForeignFutureCompleteI8)(uint64_t, UniffiForeignFutureStructI8
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_U16
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_U16
typedef struct UniffiForeignFutureStructU16 {
    uint16_t returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructU16;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_U16
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_U16
typedef void (*UniffiForeignFutureCompleteU16)(uint64_t, UniffiForeignFutureStructU16
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_I16
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_I16
typedef struct UniffiForeignFutureStructI16 {
    int16_t returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructI16;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_I16
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_I16
typedef void (*UniffiForeignFutureCompleteI16)(uint64_t, UniffiForeignFutureStructI16
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_U32
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_U32
typedef struct UniffiForeignFutureStructU32 {
    uint32_t returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructU32;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_U32
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_U32
typedef void (*UniffiForeignFutureCompleteU32)(uint64_t, UniffiForeignFutureStructU32
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_I32
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_I32
typedef struct UniffiForeignFutureStructI32 {
    int32_t returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructI32;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_I32
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_I32
typedef void (*UniffiForeignFutureCompleteI32)(uint64_t, UniffiForeignFutureStructI32
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_U64
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_U64
typedef struct UniffiForeignFutureStructU64 {
    uint64_t returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructU64;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_U64
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_U64
typedef void (*UniffiForeignFutureCompleteU64)(uint64_t, UniffiForeignFutureStructU64
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_I64
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_I64
typedef struct UniffiForeignFutureStructI64 {
    int64_t returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructI64;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_I64
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_I64
typedef void (*UniffiForeignFutureCompleteI64)(uint64_t, UniffiForeignFutureStructI64
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_F32
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_F32
typedef struct UniffiForeignFutureStructF32 {
    float returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructF32;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_F32
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_F32
typedef void (*UniffiForeignFutureCompleteF32)(uint64_t, UniffiForeignFutureStructF32
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_F64
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_F64
typedef struct UniffiForeignFutureStructF64 {
    double returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructF64;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_F64
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_F64
typedef void (*UniffiForeignFutureCompleteF64)(uint64_t, UniffiForeignFutureStructF64
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_POINTER
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_POINTER
typedef struct UniffiForeignFutureStructPointer {
    void*_Nonnull returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructPointer;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_POINTER
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_POINTER
typedef void (*UniffiForeignFutureCompletePointer)(uint64_t, UniffiForeignFutureStructPointer
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_RUST_BUFFER
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_RUST_BUFFER
typedef struct UniffiForeignFutureStructRustBuffer {
    RustBuffer returnValue;
    RustCallStatus callStatus;
} UniffiForeignFutureStructRustBuffer;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_RUST_BUFFER
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_RUST_BUFFER
typedef void (*UniffiForeignFutureCompleteRustBuffer)(uint64_t, UniffiForeignFutureStructRustBuffer
    );

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_VOID
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_STRUCT_VOID
typedef struct UniffiForeignFutureStructVoid {
    RustCallStatus callStatus;
} UniffiForeignFutureStructVoid;

#endif
#ifndef UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_VOID
#define UNIFFI_FFIDEF_FOREIGN_FUTURE_COMPLETE_VOID
typedef void (*UniffiForeignFutureCompleteVoid)(uint64_t, UniffiForeignFutureStructVoid
    );

#endif
#ifndef UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD0
#define UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD0
typedef void (*UniffiCallbackInterfaceBleApiMethod0)(uint64_t, void* _Nonnull,
        RustCallStatus *_Nonnull uniffiCallStatus
    );

#endif
#ifndef UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD1
#define UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD1
typedef void (*UniffiCallbackInterfaceBleApiMethod1)(uint64_t, void* _Nonnull,
        RustCallStatus *_Nonnull uniffiCallStatus
    );

#endif
#ifndef UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD2
#define UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD2
typedef void (*UniffiCallbackInterfaceBleApiMethod2)(uint64_t, RustBuffer* _Nonnull,
        RustCallStatus *_Nonnull uniffiCallStatus
    );

#endif
#ifndef UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD3
#define UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD3
typedef void (*UniffiCallbackInterfaceBleApiMethod3)(uint64_t, RustBuffer, void* _Nonnull,
        RustCallStatus *_Nonnull uniffiCallStatus
    );

#endif
#ifndef UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD4
#define UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD4
typedef void (*UniffiCallbackInterfaceBleApiMethod4)(uint64_t, RustBuffer, RustBuffer, void* _Nonnull,
        RustCallStatus *_Nonnull uniffiCallStatus
    );

#endif
#ifndef UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD5
#define UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD5
typedef void (*UniffiCallbackInterfaceBleApiMethod5)(uint64_t, RustBuffer, RustBuffer* _Nonnull,
        RustCallStatus *_Nonnull uniffiCallStatus
    );

#endif
#ifndef UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD6
#define UNIFFI_FFIDEF_CALLBACK_INTERFACE_BLE_API_METHOD6
typedef void (*UniffiCallbackInterfaceBleApiMethod6)(uint64_t, RustBuffer, void* _Nonnull,
        RustCallStatus *_Nonnull uniffiCallStatus
    );

#endif
#ifndef UNIFFI_FFIDEF_V_TABLE_CALLBACK_INTERFACE_BLE_API
#define UNIFFI_FFIDEF_V_TABLE_CALLBACK_INTERFACE_BLE_API
typedef struct UniffiVTableCallbackInterfaceBleApi {
    UniffiCallbackInterfaceBleApiMethod0 _Nonnull startScan;
    UniffiCallbackInterfaceBleApiMethod1 _Nonnull stopScan;
    UniffiCallbackInterfaceBleApiMethod2 _Nonnull deviceNames;
    UniffiCallbackInterfaceBleApiMethod3 _Nonnull open;
    UniffiCallbackInterfaceBleApiMethod4 _Nonnull write;
    UniffiCallbackInterfaceBleApiMethod5 _Nonnull read;
    UniffiCallbackInterfaceBleApiMethod6 _Nonnull close;
    UniffiCallbackInterfaceFree _Nonnull uniffiFree;
} UniffiVTableCallbackInterfaceBleApi;

#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_CLONE_BLEAPI
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_CLONE_BLEAPI
void*_Nonnull uniffi_sideswap_jade_fn_clone_bleapi(void*_Nonnull ptr, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_FREE_BLEAPI
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_FREE_BLEAPI
void uniffi_sideswap_jade_fn_free_bleapi(void*_Nonnull ptr, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_INIT_CALLBACK_VTABLE_BLEAPI
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_INIT_CALLBACK_VTABLE_BLEAPI
void uniffi_sideswap_jade_fn_init_callback_vtable_bleapi(UniffiVTableCallbackInterfaceBleApi* _Nonnull vtable
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_START_SCAN
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_START_SCAN
void uniffi_sideswap_jade_fn_method_bleapi_start_scan(void*_Nonnull ptr, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_STOP_SCAN
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_STOP_SCAN
void uniffi_sideswap_jade_fn_method_bleapi_stop_scan(void*_Nonnull ptr, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_DEVICE_NAMES
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_DEVICE_NAMES
RustBuffer uniffi_sideswap_jade_fn_method_bleapi_device_names(void*_Nonnull ptr, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_OPEN
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_OPEN
void uniffi_sideswap_jade_fn_method_bleapi_open(void*_Nonnull ptr, RustBuffer device_name, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_WRITE
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_WRITE
void uniffi_sideswap_jade_fn_method_bleapi_write(void*_Nonnull ptr, RustBuffer device_name, RustBuffer buf, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_READ
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_READ
RustBuffer uniffi_sideswap_jade_fn_method_bleapi_read(void*_Nonnull ptr, RustBuffer device_name, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_CLOSE
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLEAPI_CLOSE
void uniffi_sideswap_jade_fn_method_bleapi_close(void*_Nonnull ptr, RustBuffer device_name, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_CLONE_BLECLIENT
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_CLONE_BLECLIENT
void*_Nonnull uniffi_sideswap_jade_fn_clone_bleclient(void*_Nonnull ptr, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_FREE_BLECLIENT
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_FREE_BLECLIENT
void uniffi_sideswap_jade_fn_free_bleclient(void*_Nonnull ptr, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_CONSTRUCTOR_BLECLIENT_NEW
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_CONSTRUCTOR_BLECLIENT_NEW
void*_Nonnull uniffi_sideswap_jade_fn_constructor_bleclient_new(void*_Nonnull ble_api, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLECLIENT_RUN
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_METHOD_BLECLIENT_RUN
void uniffi_sideswap_jade_fn_method_bleclient_run(void*_Nonnull ptr, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_FUNC_LOG
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_FN_FUNC_LOG
void uniffi_sideswap_jade_fn_func_log(RustBuffer msg, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUSTBUFFER_ALLOC
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUSTBUFFER_ALLOC
RustBuffer ffi_sideswap_jade_rustbuffer_alloc(uint64_t size, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUSTBUFFER_FROM_BYTES
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUSTBUFFER_FROM_BYTES
RustBuffer ffi_sideswap_jade_rustbuffer_from_bytes(ForeignBytes bytes, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUSTBUFFER_FREE
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUSTBUFFER_FREE
void ffi_sideswap_jade_rustbuffer_free(RustBuffer buf, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUSTBUFFER_RESERVE
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUSTBUFFER_RESERVE
RustBuffer ffi_sideswap_jade_rustbuffer_reserve(RustBuffer buf, uint64_t additional, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_U8
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_U8
void ffi_sideswap_jade_rust_future_poll_u8(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_U8
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_U8
void ffi_sideswap_jade_rust_future_cancel_u8(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_U8
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_U8
void ffi_sideswap_jade_rust_future_free_u8(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_U8
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_U8
uint8_t ffi_sideswap_jade_rust_future_complete_u8(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_I8
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_I8
void ffi_sideswap_jade_rust_future_poll_i8(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_I8
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_I8
void ffi_sideswap_jade_rust_future_cancel_i8(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_I8
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_I8
void ffi_sideswap_jade_rust_future_free_i8(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_I8
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_I8
int8_t ffi_sideswap_jade_rust_future_complete_i8(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_U16
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_U16
void ffi_sideswap_jade_rust_future_poll_u16(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_U16
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_U16
void ffi_sideswap_jade_rust_future_cancel_u16(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_U16
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_U16
void ffi_sideswap_jade_rust_future_free_u16(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_U16
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_U16
uint16_t ffi_sideswap_jade_rust_future_complete_u16(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_I16
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_I16
void ffi_sideswap_jade_rust_future_poll_i16(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_I16
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_I16
void ffi_sideswap_jade_rust_future_cancel_i16(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_I16
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_I16
void ffi_sideswap_jade_rust_future_free_i16(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_I16
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_I16
int16_t ffi_sideswap_jade_rust_future_complete_i16(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_U32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_U32
void ffi_sideswap_jade_rust_future_poll_u32(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_U32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_U32
void ffi_sideswap_jade_rust_future_cancel_u32(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_U32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_U32
void ffi_sideswap_jade_rust_future_free_u32(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_U32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_U32
uint32_t ffi_sideswap_jade_rust_future_complete_u32(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_I32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_I32
void ffi_sideswap_jade_rust_future_poll_i32(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_I32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_I32
void ffi_sideswap_jade_rust_future_cancel_i32(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_I32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_I32
void ffi_sideswap_jade_rust_future_free_i32(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_I32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_I32
int32_t ffi_sideswap_jade_rust_future_complete_i32(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_U64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_U64
void ffi_sideswap_jade_rust_future_poll_u64(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_U64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_U64
void ffi_sideswap_jade_rust_future_cancel_u64(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_U64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_U64
void ffi_sideswap_jade_rust_future_free_u64(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_U64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_U64
uint64_t ffi_sideswap_jade_rust_future_complete_u64(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_I64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_I64
void ffi_sideswap_jade_rust_future_poll_i64(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_I64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_I64
void ffi_sideswap_jade_rust_future_cancel_i64(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_I64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_I64
void ffi_sideswap_jade_rust_future_free_i64(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_I64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_I64
int64_t ffi_sideswap_jade_rust_future_complete_i64(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_F32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_F32
void ffi_sideswap_jade_rust_future_poll_f32(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_F32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_F32
void ffi_sideswap_jade_rust_future_cancel_f32(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_F32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_F32
void ffi_sideswap_jade_rust_future_free_f32(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_F32
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_F32
float ffi_sideswap_jade_rust_future_complete_f32(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_F64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_F64
void ffi_sideswap_jade_rust_future_poll_f64(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_F64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_F64
void ffi_sideswap_jade_rust_future_cancel_f64(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_F64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_F64
void ffi_sideswap_jade_rust_future_free_f64(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_F64
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_F64
double ffi_sideswap_jade_rust_future_complete_f64(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_POINTER
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_POINTER
void ffi_sideswap_jade_rust_future_poll_pointer(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_POINTER
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_POINTER
void ffi_sideswap_jade_rust_future_cancel_pointer(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_POINTER
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_POINTER
void ffi_sideswap_jade_rust_future_free_pointer(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_POINTER
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_POINTER
void*_Nonnull ffi_sideswap_jade_rust_future_complete_pointer(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_RUST_BUFFER
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_RUST_BUFFER
void ffi_sideswap_jade_rust_future_poll_rust_buffer(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_RUST_BUFFER
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_RUST_BUFFER
void ffi_sideswap_jade_rust_future_cancel_rust_buffer(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_RUST_BUFFER
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_RUST_BUFFER
void ffi_sideswap_jade_rust_future_free_rust_buffer(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_RUST_BUFFER
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_RUST_BUFFER
RustBuffer ffi_sideswap_jade_rust_future_complete_rust_buffer(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_VOID
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_POLL_VOID
void ffi_sideswap_jade_rust_future_poll_void(uint64_t handle, UniffiRustFutureContinuationCallback _Nonnull callback, uint64_t callback_data
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_VOID
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_CANCEL_VOID
void ffi_sideswap_jade_rust_future_cancel_void(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_VOID
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_FREE_VOID
void ffi_sideswap_jade_rust_future_free_void(uint64_t handle
);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_VOID
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_RUST_FUTURE_COMPLETE_VOID
void ffi_sideswap_jade_rust_future_complete_void(uint64_t handle, RustCallStatus *_Nonnull out_status
);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_FUNC_LOG
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_FUNC_LOG
uint16_t uniffi_sideswap_jade_checksum_func_log(void

);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_START_SCAN
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_START_SCAN
uint16_t uniffi_sideswap_jade_checksum_method_bleapi_start_scan(void

);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_STOP_SCAN
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_STOP_SCAN
uint16_t uniffi_sideswap_jade_checksum_method_bleapi_stop_scan(void

);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_DEVICE_NAMES
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_DEVICE_NAMES
uint16_t uniffi_sideswap_jade_checksum_method_bleapi_device_names(void

);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_OPEN
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_OPEN
uint16_t uniffi_sideswap_jade_checksum_method_bleapi_open(void

);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_WRITE
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_WRITE
uint16_t uniffi_sideswap_jade_checksum_method_bleapi_write(void

);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_READ
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_READ
uint16_t uniffi_sideswap_jade_checksum_method_bleapi_read(void

);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_CLOSE
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLEAPI_CLOSE
uint16_t uniffi_sideswap_jade_checksum_method_bleapi_close(void

);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLECLIENT_RUN
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_METHOD_BLECLIENT_RUN
uint16_t uniffi_sideswap_jade_checksum_method_bleclient_run(void

);
#endif
#ifndef UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_CONSTRUCTOR_BLECLIENT_NEW
#define UNIFFI_FFIDEF_UNIFFI_SIDESWAP_JADE_CHECKSUM_CONSTRUCTOR_BLECLIENT_NEW
uint16_t uniffi_sideswap_jade_checksum_constructor_bleclient_new(void

);
#endif
#ifndef UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_UNIFFI_CONTRACT_VERSION
#define UNIFFI_FFIDEF_FFI_SIDESWAP_JADE_UNIFFI_CONTRACT_VERSION
uint32_t ffi_sideswap_jade_uniffi_contract_version(void

);
#endif

