import 'package:flutter/material.dart';
import '../screen/login_screen.dart';

class BillAiApp extends StatelessWidget {
  const BillAiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'BillAI',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3: true),
    home: const LoginScreen(),
  );
}
