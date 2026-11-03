import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}
class _ScannerScreenState extends State<ScannerScreen> {
  String? result;
  @override
  Widget build(BuildContext context) {
    if (result != null) {
      return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('QR-код считан', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SelectableText(result!),
        const SizedBox(height: 16),
        const Text('Обработка и сохранение чека будут доступны после подключения сервиса чеков.'),
        const SizedBox(height: 20),
        FilledButton(onPressed: () => setState(() => result = null), child: const Text('Сканировать ещё')),
      ]));
    }
    return Stack(children: [
      MobileScanner(onDetect: (capture) {
        for (final barcode in capture.barcodes) {
          final value = barcode.rawValue;
          if (value != null && value.isNotEmpty && result == null) {
            setState(() => result = value);
            break;
          }
        }
      }, errorBuilder: (context, error) => const Center(child: Text('Не удалось открыть камеру. Проверьте разрешение в настройках устройства.'))),
      const Align(alignment: Alignment.bottomCenter, child: Padding(
        padding: EdgeInsets.all(24), child: Text('Наведите камеру на QR-код чека', style: TextStyle(color: Colors.white, shadows: [Shadow(blurRadius: 5, color: Colors.black)])),
      )),
    ]);
  }
}
