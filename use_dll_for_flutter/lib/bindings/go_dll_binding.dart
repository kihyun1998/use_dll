import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:use_dll_for_flutter/bindings/models/go_res_value.dart';
import 'package:use_dll_for_flutter/utils/dll_path_provider.dart';

// DLL 함수 시그니처 정의
typedef CallBasic2Native = GoResValue Function(
    Pointer<Utf8> key, Pointer<Utf8> msg);
typedef CallBasic2Dart = GoResValue Function(
    Pointer<Utf8> key, Pointer<Utf8> msg);

// 메모리 해제 함수 정의
typedef FreeStringNative = Void Function(Pointer<Utf8>);
typedef FreeStringDart = void Function(Pointer<Utf8>);

class GoDllBinding {
  late DynamicLibrary _dylib;
  late CallBasic2Dart _callBasic2;
  late FreeStringDart _freeString;

  static final GoDllBinding _instance = GoDllBinding._internal();

  factory GoDllBinding() {
    return _instance;
  }

  GoDllBinding._internal() {
    // DLL 로드
    _dylib = DynamicLibrary.open(DllPathProvider.getDllPath('mylib'));

    // 함수 로드
    _callBasic2 =
        _dylib.lookupFunction<CallBasic2Native, CallBasic2Dart>('CallBasic2');
    _freeString =
        _dylib.lookupFunction<FreeStringNative, FreeStringDart>('FreeString');
  }

  GoResValue callBasic2(String key, String message) {
    final keyPtr = key.toNativeUtf8();
    final msgPtr = message.toNativeUtf8();

    try {
      return _callBasic2(keyPtr, msgPtr);
    } finally {
      malloc.free(keyPtr);
      malloc.free(msgPtr);
    }
  }

  void freeString(Pointer<Utf8> ptr) {
    _freeString(ptr);
  }
}
