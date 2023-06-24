import 'package:go_router/go_router.dart';
import 'package:movie_app/routing/route_utils.dart';
import 'package:movie_app/ui/login.dart';

import '../services/app_services.dart';
import '../ui/error_page.dart';
import '../ui/home.dart';
import '../ui/splash.dart';

class AppRouter {
  late final AppService appService;
  GoRouter get router => _goRouter;

  AppRouter(this.appService);

  late final GoRouter _goRouter = GoRouter(
    refreshListenable: appService,
    initialLocation: APP_PAGE.splash.toPath,
    routes: <GoRoute>[
      GoRoute(
        path: APP_PAGE.home.toPath,
        name: APP_PAGE.home.toName,
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: APP_PAGE.splash.toPath,
        name: APP_PAGE.splash.toName,
        builder: (context, state) => const Splash(),
      ),
      GoRoute(
        path: APP_PAGE.loginhome.toPath,
        name: APP_PAGE.loginhome.toName,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: APP_PAGE.error.toPath,
        name: APP_PAGE.error.toName,
        builder: (context, state) => ErrorPage(error: state.extra.toString()),
      ),
    ],
    errorBuilder: (context, state) {
      print('error builder');
      return ErrorPage(error: state.error.toString());
    },
    redirect: (state) {
      final loginHomeLocation = state.namedLocation(APP_PAGE.loginhome.toName);
      final homeLocation = state.namedLocation(APP_PAGE.home.toName);
      final splashLocation = state.namedLocation(APP_PAGE.splash.toName);

      final isLoggedIn = appService.loginState;
      final isInitialized = appService.initialized;

      //final isOnboarded = appService.onboarding;

      final isGoingToLogin = (state.subloc == loginHomeLocation);
      final isGoingToInit = state.subloc == splashLocation;

      final isGoneHome = state.subloc == homeLocation;

      //final isGoingToOnboard = state.subloc == onboardLocation;

      // If not Initialized and not going to Initialized redirect to Splash
      if (!isInitialized) {
        if (!isGoingToInit) return splashLocation;
      } else {
        if (!isLoggedIn) {
          if (!isGoingToLogin) return loginHomeLocation;
        } else {
          if (!isGoneHome) {
            return homeLocation;
          } else {
            return null;
          }
        }
      }
      return null;
    },
  );
}
