import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/github_service.dart';
import 'services/local_storage_service.dart';
import 'viewmodels/search_viewmodel.dart';
import 'views/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => GithubService()),
        Provider(create: (_) => LocalStorageService()),
        ChangeNotifierProvider(
          create: (context) => SearchViewModel(
            context.read<GithubService>(),
            context.read<LocalStorageService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'GitHub Search',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const SearchScreen(),
      ),
    );
  }
}
