import 'package:festeasy/app/router/auth_service.dart';
import 'package:festeasy/app/view/welcome_page.dart';
import 'package:festeasy/features/auth/presentation/pages/client_register_page.dart';
import 'package:festeasy/client/create_request/view/service_request_page.dart';
import 'package:festeasy/features/home/presentation/pages/client/client_home_page.dart';
import 'package:festeasy/features/home/presentation/pages/client/party_type_page.dart';
import 'package:festeasy/client/payment/view/confirm_payment_page.dart';
import 'package:festeasy/client/payment/view/proposal_detail_page.dart';
import 'package:festeasy/client/payment/view/reservation_confirmed_page.dart';
import 'package:festeasy/features/profile/presentation/pages/client/client_profile_page.dart';
import 'package:festeasy/features/requests/presentation/pages/client/client_requests_page.dart';
import 'package:festeasy/features/requests/presentation/pages/client/request_detail_page.dart';
import 'package:festeasy/dashboard/view/dashboard_page.dart';
import 'package:festeasy/features/auth/presentation/pages/login_page.dart';
// Provider specific pages
import 'package:festeasy/features/requests/presentation/pages/requests_list_page.dart';
import 'package:festeasy/features/requests/presentation/pages/request_detail_page.dart'
    as provider_request_detail; // Alias to avoid conflict
import 'package:festeasy/features/requests/presentation/pages/send_quote_page.dart';
import 'package:festeasy/features/requests/presentation/pages/success_page.dart'
    as provider_success; // Alias
import 'package:festeasy/features/profile/presentation/pages/provider/profile_page.dart'
    as provider_profile; // Alias
import 'package:festeasy/services/view/services_page.dart'
    as provider_services; // Alias
import 'package:festeasy/calendar/view/calendar_page.dart'
    as provider_calendar; // Alias
import 'package:festeasy/features/requests/presentation/pages/ongoing_requests_page.dart'
    as provider_ongoing; // Alias
import 'package:festeasy/features/profile/presentation/pages/provider/edit_profile_page.dart'
    as provider_edit_profile; // Alias
import 'package:festeasy/chat/view/messages_list_page.dart'
    as provider_messages; // Alias
import 'package:festeasy/chat/view/chat_detail_page.dart'
    as provider_chat_detail; // Alias
import 'package:festeasy/settings/view/settings_page.dart'
    as provider_settings; // Alias
import 'package:festeasy/calendar/view/confirmed_event_page.dart'
    as provider_confirmed_event; // Alias

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter(this.authService);

  final AuthService authService;

  late final GoRouter router = GoRouter(
    refreshListenable: authService,
    initialLocation: '/',
    routes: <GoRoute>[
      // --- APP ENTRYPOINT ---
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomePage(),
      ),

      // --- Unified Login ---
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            const LoginPage(), // The unified login page
      ),

      // --- PROVIDER FLOW ---
      GoRoute(
        path: '/provider/dashboard',
        builder: (context, state) => const DashboardPage(),
        routes: [
          // Requests
          GoRoute(
            path: 'requests', // /provider/dashboard/requests
            builder: (context, state) => const RequestsListPage(),
            routes: [
              GoRoute(
                path: ':id', // /provider/dashboard/requests/:id
                builder: (context, state) =>
                    provider_request_detail.RequestDetailPage(
                      requestId: state.pathParameters['id']!,
                    ),
                routes: [
                  GoRoute(
                    path:
                        'send-quote', // /provider/dashboard/requests/:id/send-quote
                    builder: (context, state) => SendQuotePage(
                      requestId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Success (for provider flow)
          GoRoute(
            path: 'success', // /provider/dashboard/success
            builder: (context, state) => const provider_success.SuccessPage(),
          ),
          // Profile
          GoRoute(
            path: 'profile', // /provider/dashboard/profile
            builder: (context, state) => const provider_profile.ProfilePage(),
            routes: [
              GoRoute(
                path: 'edit', // /provider/dashboard/profile/edit
                builder: (context, state) =>
                    const provider_edit_profile.EditProfilePage(),
              ),
            ],
          ),
          // Services
          GoRoute(
            path: 'services', // /provider/dashboard/services
            builder: (context, state) => const provider_services.ServicesPage(),
          ),
          // Calendar
          GoRoute(
            path: 'calendar', // /provider/dashboard/calendar
            builder: (context, state) => const provider_calendar.CalendarPage(),
            routes: [
              GoRoute(
                path:
                    'events/:eventId', // /provider/dashboard/calendar/events/:eventId
                builder: (context, state) =>
                    provider_confirmed_event.ConfirmedEventPage(
                      eventId: state.pathParameters['eventId']!,
                    ),
              ),
            ],
          ),
          // Ongoing Requests
          GoRoute(
            path: 'ongoing-requests', // /provider/dashboard/ongoing-requests
            builder: (context, state) =>
                const provider_ongoing.OngoingRequestsPage(),
          ),
          // Messages
          GoRoute(
            path: 'messages', // /provider/dashboard/messages
            builder: (context, state) =>
                const provider_messages.MessagesListPage(), // Corrected name
            routes: [
              GoRoute(
                path: ':chatId', // /provider/dashboard/messages/:chatId
                builder: (context, state) =>
                    provider_chat_detail.ChatDetailPage(
                      chatId: state.pathParameters['chatId']!,
                    ),
              ),
            ],
          ),
          // Settings
          GoRoute(
            path: 'settings', // /provider/dashboard/settings
            builder: (context, state) => const provider_settings.SettingsPage(),
          ),
        ],
      ),

      // --- CLIENT FLOW ---
      GoRoute(
        path: '/client/register',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ClientRegisterPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      GoRoute(
        path: '/client/party-type',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const PartyTypePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      GoRoute(
        path: '/client/home',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ClientHomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      GoRoute(
        path: '/client/create-request',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ServiceRequestPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      GoRoute(
        path: '/client/requests',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ClientRequestsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      GoRoute(
        path: '/client/request-detail/:id',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: ClientRequestDetailPage(
            requestId: state.pathParameters['id']!,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      GoRoute(
        path: '/client/proposal-detail/:id',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: ProposalDetailPage(proposalId: state.pathParameters['id']!),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      GoRoute(
        path: '/client/payment',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ConfirmPaymentPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      GoRoute(
        path: '/client/success',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ReservationConfirmedPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      GoRoute(
        // Client profile route
        path: '/client/profile',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ClientProfilePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool isAuthenticated = authService.isAuthenticated;
      final bool isAtLoginOrWelcome =
          state.matchedLocation == '/' || state.matchedLocation == '/login';
      final bool isAtRegister = state.matchedLocation == '/client/register';

      // If user is authenticated and tries to access login, welcome, or register, redirect to client home
      if (isAuthenticated && (isAtLoginOrWelcome || isAtRegister)) {
        return '/client/home';
      }
      // Allow access to login, welcome, and register without authentication
      // if (!isAuthenticated && !isAtLoginOrWelcome && !isAtRegister) {
      //   return '/';
      // }
      return null;
    },
  );
}
