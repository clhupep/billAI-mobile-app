import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final form = GlobalKey<FormState>();
  bool loading = false;
  String? error;
  @override
  void dispose() { email.dispose(); super.dispose(); }
  Future<void> login() async {
    if (!form.currentState!.validate()) return;
    setState(() { loading = true; error = null; });
    try {
      final address = email.text.trim();
      final id = await ApiService().login(address);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(userId: id, email: address)));
    } catch (_) {
      if (mounted) setState(() => error = 'Не удалось войти. Проверьте email и подключение к серверу.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(
    child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420), child: Form(key: form, child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Icon(Icons.receipt_long, size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 20),
          Text('BillAI', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('Войдите, чтобы отслеживать расходы', textAlign: TextAlign.center),
          const SizedBox(height: 32),
          TextFormField(controller: email, keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email], decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            validator: (value) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value?.trim() ?? '') ? null : 'Введите корректный email'),
          if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          const SizedBox(height: 20),
          FilledButton(onPressed: loading ? null : login, child: Text(loading ? 'Вход…' : 'Войти')),
        ],
      )),
    )),
  )));
}
