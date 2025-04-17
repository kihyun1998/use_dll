import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go DLL Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Go DLL Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Go에서 반환하는 구조체 정의
final class GoResValue extends Struct {
  external Pointer<Utf8> msg;

  @Int8()
  external int isOk;
}

// DLL 함수 시그니처 정의
typedef CallBasic2Native = GoResValue Function(
    Pointer<Utf8> key, Pointer<Utf8> msg);
typedef CallBasic2Dart = GoResValue Function(
    Pointer<Utf8> key, Pointer<Utf8> msg);

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _result = '';
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _keyController.text = 'valid_key'; // 기본값 설정
  }

  @override
  void dispose() {
    _keyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _callGoDLL() {
    try {
      // DLL 로드 (mylib.dll 파일은 실행 파일과 같은 경로에 있어야 함)
      final DynamicLibrary dylib = DynamicLibrary.open('mylib.dll');

      // 함수 로드
      final CallBasic2Dart callBasic2 =
          dylib.lookupFunction<CallBasic2Native, CallBasic2Dart>('CallBasic2');

      // 입력 문자열을 C 문자열로 변환
      final keyPtr = _keyController.text.toNativeUtf8();
      final msgPtr = _messageController.text.toNativeUtf8();

      try {
        // 함수 호출 및 결과 받기
        final result = callBasic2(keyPtr, msgPtr);

        // 결과 변환
        final resultMsg = result.msg.toDartString();
        final isOk = result.isOk != 0;

        setState(() {
          _result = resultMsg;
          _isSuccess = isOk;
        });

        // C 문자열 메모리 해제 (중요!)
        // calloc.free(result.msg);
      } finally {
        // 입력 포인터 메모리 해제
        calloc.free(keyPtr);
        calloc.free(msgPtr);
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'Enter API key (try "valid_key")',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Enter your message',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _callGoDLL,
              child: const Text('Call Go Function'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Result:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isSuccess ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _result.isEmpty ? 'No result yet' : _result,
                style: TextStyle(
                  color:
                      _isSuccess ? Colors.green.shade900 : Colors.red.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
