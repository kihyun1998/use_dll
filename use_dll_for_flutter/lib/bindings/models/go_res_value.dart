import 'dart:ffi';

import 'package:ffi/ffi.dart';

// Go에서 반환하는 구조체 정의
final class GoResValue extends Struct {
  external Pointer<Utf8> msg;

  @Int8()
  external int isOk;
}
