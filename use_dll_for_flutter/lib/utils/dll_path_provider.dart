import 'dart:io';

class DllPathProvider {
  static String getDllPath(String name) {
    if (Platform.isWindows) {
      return '$name.dll';
    } else if (Platform.isMacOS) {
      return 'lib$name.dylib';
    } else if (Platform.isLinux) {
      return 'lib$name.so';
    } else {
      throw UnsupportedError('Unsupported platform for FFI');
    }
  }
}
