import 'package:festeasy/features/profile/presentation/pages/provider/profile_page.dart';
import 'package:festeasy/features/quotes/presentation/pages/provider_quotes_page.dart';
import 'package:festeasy/features/requests/domain/usecases/get_provider_new_requests_usecase.dart';
import 'package:festeasy/features/requests/domain/usecases/get_requests_usecase.dart';
import 'package:festeasy/features/requests/presentation/bloc/requests_cubit.dart';
import 'package:festeasy/features/requests/presentation/pages/requests_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../app/router/auth_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Definimos las páginas dentro del build para asegurar que tengan el contexto correcto
    final List<Widget> pages = [
      const _RequestsTab(),
      const ProviderQuotesPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFFEF4444),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_quote),
            label: 'Cotizaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _RequestsTab extends StatelessWidget {
  const _RequestsTab();

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser;
    if (user == null) {
      return const Center(child: Text('Error: Usuario no identificado'));
    }

    return BlocProvider(
      create: (context) => RequestsCubit(
        context.read<GetRequestsUseCase>(),
        context.read<GetProviderNewRequestsUseCase>(),
      )..loadProviderNewRequests(user.id),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Solicitudes Nuevas',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFFF3F4F6),
        body: const RequestsListBody(),
      ),
    );
  }
}
