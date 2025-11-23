import 'package:festeasy/app/router/app_router.dart';
import 'package:festeasy/app/router/auth_service.dart';
import 'package:festeasy/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:festeasy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:festeasy/features/auth/domain/repositories/auth_repository.dart';
import 'package:festeasy/features/auth/domain/usecases/login_usecase.dart';
import 'package:festeasy/features/auth/domain/usecases/register_usecase.dart';
import 'package:festeasy/features/requests/data/datasources/requests_remote_datasource.dart';
import 'package:festeasy/features/requests/data/repositories/requests_repository_impl.dart';
import 'package:festeasy/features/requests/domain/repositories/requests_repository.dart';
import 'package:festeasy/features/requests/domain/usecases/get_requests_usecase.dart';
import 'package:festeasy/features/quotes/data/datasources/quote_remote_datasource.dart';
import 'package:festeasy/features/quotes/data/repositories/quote_repository_impl.dart';
import 'package:festeasy/features/quotes/domain/repositories/quote_repository.dart';
import 'package:festeasy/features/quotes/domain/usecases/accept_quote.dart';
import 'package:festeasy/features/quotes/domain/usecases/create_quote.dart';
import 'package:festeasy/features/quotes/domain/usecases/get_quotes_for_request.dart';
import 'package:festeasy/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final supabaseClient = Supabase.instance.client;

    return MultiRepositoryProvider(
      providers: [
        // Auth DataSources and Repository
        RepositoryProvider<AuthRemoteDataSource>(
          create: (_) => AuthRemoteDataSourceImpl(
            supabaseClient: supabaseClient,
          ),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            context.read<AuthRemoteDataSource>(),
          ),
        ),

        // Auth Use Cases
        RepositoryProvider<LoginUseCase>(
          create: (context) => LoginUseCase(context.read<AuthRepository>()),
        ),
        RepositoryProvider<RegisterUseCase>(
          create: (context) => RegisterUseCase(context.read<AuthRepository>()),
        ),

        // Requests DataSources and Repository
        RepositoryProvider<RequestsRemoteDataSource>(
          create: (_) => RequestsRemoteDataSourceImpl(
            supabaseClient: supabaseClient,
          ),
        ),
        RepositoryProvider<RequestsRepository>(
          create: (context) => RequestsRepositoryImpl(
            context.read<RequestsRemoteDataSource>(),
          ),
        ),

        // Requests Use Cases
        RepositoryProvider<GetRequestsUseCase>(
          create: (context) =>
              GetRequestsUseCase(context.read<RequestsRepository>()),
        ),

        // Quotes DataSources and Repository
        RepositoryProvider<QuoteRemoteDataSource>(
          create: (_) => QuoteRemoteDataSourceImpl(
            supabaseClient: supabaseClient,
          ),
        ),
        RepositoryProvider<QuoteRepository>(
          create: (context) => QuoteRepositoryImpl(
            context.read<QuoteRemoteDataSource>(),
          ),
        ),

        // Quotes Use Cases
        RepositoryProvider<GetQuotesForRequest>(
          create: (context) =>
              GetQuotesForRequest(context.read<QuoteRepository>()),
        ),
        RepositoryProvider<CreateQuote>(
          create: (context) => CreateQuote(context.read<QuoteRepository>()),
        ),
        RepositoryProvider<AcceptQuote>(
          create: (context) => AcceptQuote(context.read<QuoteRepository>()),
        ),
      ],
      child: ChangeNotifierProvider<AuthService>.value(
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
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFEF4444),
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _appRouter.router,
        ),
      ),
    );
  }
}
