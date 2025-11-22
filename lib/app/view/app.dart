import 'package:festeasy/app/router/app_router.dart';
import 'package:festeasy/app/router/auth_service.dart';
import 'package:festeasy/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthService _authService;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _appRouter = AppRouter(_authService);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>.value(
      value: _authService,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: IconThemeData(color: Color(0xFF1F2937)),
            titleTextStyle: TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEF4444)),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _appRouter.router,
      ),
    );
  }
}