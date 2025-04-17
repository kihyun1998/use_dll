import 'package:flutter/material.dart';

class ResultDisplay extends StatelessWidget {
  final String result;
  final bool isSuccess;

  const ResultDisplay({
    super.key,
    required this.result,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSuccess ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        result.isEmpty ? 'No result yet' : result,
        style: TextStyle(
          color: isSuccess ? Colors.green.shade900 : Colors.red.shade900,
        ),
      ),
    );
  }
}
