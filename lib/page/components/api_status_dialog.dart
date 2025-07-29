import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../config/api_config.dart';

class ApiStatusDialog extends StatefulWidget {
  const ApiStatusDialog({Key? key}) : super(key: key);

  @override
  _ApiStatusDialogState createState() => _ApiStatusDialogState();
}

class _ApiStatusDialogState extends State<ApiStatusDialog> {
  bool _isChecking = true;
  bool _isConnected = false;
  String _statusMessage = 'Checking connection...';

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _isChecking = true;
      _statusMessage = 'Checking connection...';
    });

    try {
      final isConnected = await ApiService.checkConnection();
      setState(() {
        _isChecking = false;
        _isConnected = isConnected;
        _statusMessage = isConnected 
            ? 'Connected to API successfully!' 
            : 'Failed to connect to API';
      });
    } catch (e) {
      setState(() {
        _isChecking = false;
        _isConnected = false;
        _statusMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _isChecking 
                ? Icons.hourglass_empty 
                : (_isConnected ? Icons.check_circle : Icons.error),
            color: _isChecking 
                ? Colors.orange 
                : (_isConnected ? Colors.green : Colors.red),
          ),
          const SizedBox(width: 8),
          const Text('API Status'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Server URL: ${ApiConfig.baseUrl}'),
          const SizedBox(height: 16),
          if (_isChecking)
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(_statusMessage),
              ],
            )
          else
            Text(
              _statusMessage,
              style: TextStyle(
                color: _isConnected ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 16),
          if (!_isConnected && !_isChecking)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Troubleshooting:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. Pastikan backend server berjalan\n'
                    '2. Cek URL API di config\n'
                    '3. Pastikan tidak ada firewall\n'
                    '4. Coba restart server',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        if (!_isConnected && !_isChecking)
          TextButton(
            onPressed: _checkConnection,
            child: const Text('Retry'),
          ),
      ],
    );
  }
} 