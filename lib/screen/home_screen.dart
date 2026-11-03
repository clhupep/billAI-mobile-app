import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.userId, required this.email});
  final String userId;
  final String email;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int selected = 0;
  late Future<List<Category>> categories;
  @override
  void initState() { super.initState(); load(); }
  void load() { categories = ApiService().categories(widget.userId); }
  @override
  Widget build(BuildContext context) {
    final pages = [
      FutureBuilder<List<Category>>(future: categories, builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) {
          return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Не удалось загрузить категории.'),
            TextButton(onPressed: () => setState(load), child: const Text('Повторить')),
          ]));
        }
        final items = snapshot.data!;
        return ListView(padding: const EdgeInsets.all(20), children: [
          Text('Мои расходы', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('История расходов появится после подключения сервиса чеков.'),
          const SizedBox(height: 24),
          Text('Категории', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (items.isEmpty) const Text('Категорий пока нет.')
          else ...items.map((category) => Card(child: ListTile(leading: const Icon(Icons.category_outlined), title: Text(category.name)))),
        ]);
      }),
      const ScannerScreen(),
      ListView(children: [
        ListTile(leading: const Icon(Icons.person_outline), title: const Text('Аккаунт'), subtitle: Text(widget.email)),
        ListTile(leading: const Icon(Icons.logout), title: const Text('Выйти'), onTap: () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
        }),
      ]),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(['Личный кабинет', 'Сканер', 'Настройки'][selected])),
      body: pages[selected],
      bottomNavigationBar: NavigationBar(selectedIndex: selected, onDestinationSelected: (index) => setState(() => selected = index), destinations: const [
        NavigationDestination(icon: Icon(Icons.account_circle_outlined), label: 'Кабинет'),
        NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'Сканер'),
        NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Настройки'),
      ]),
    );
  }
}
