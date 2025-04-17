import 'package:flutter/material.dart';
import 'package:use_dll_for_flutter/screens/home/widgets/result_display.dart';
import 'package:use_dll_for_flutter/services/go_dll_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _goDllService = GoDllService();

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

  Future<void> _callGoDLL() async {
    final result = await _goDllService.callBasic2(
      _keyController.text,
      _messageController.text,
    );

    setState(() {
      _result = result.message;
      _isSuccess = result.isSuccess;
    });
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
            ResultDisplay(
              result: _result,
              isSuccess: _isSuccess,
            ),
          ],
        ),
      ),
    );
  }
}
