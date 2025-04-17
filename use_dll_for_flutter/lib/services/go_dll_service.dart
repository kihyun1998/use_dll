import 'package:ffi/ffi.dart';
import 'package:use_dll_for_flutter/bindings/go_dll_binding.dart';

class GoDllService {
  final _binding = GoDllBinding();

  Future<GoDllResult> callBasic2(String key, String message) async {
    try {
      final result = _binding.callBasic2(key, message);

      // 결과 변환
      final resultMsg = result.msg.toDartString();
      final isOk = result.isOk != 0;

      // Go에서 할당한 메모리 해제
      _binding.freeString(result.msg);

      return GoDllResult(message: resultMsg, isSuccess: isOk);
    } catch (e) {
      return GoDllResult(
        message: 'Error: $e',
        isSuccess: false,
      );
    }
  }
}

class GoDllResult {
  final String message;
  final bool isSuccess;

  GoDllResult({
    required this.message,
    required this.isSuccess,
  });
}
