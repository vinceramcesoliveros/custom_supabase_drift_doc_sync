import 'package:auto_route/auto_route.dart';
import 'package:custom_supabase_drift_sync/core/navigation/router.gr.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard({
    required this.ref,
  });
  Ref ref;
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    final session = ref.watch(sessionPProvider);
    if (session.isSome()) {
      // if user is authenticated we continue
      resolver.next();
    } else {
      resolver.redirect(const SignupRoute());
    }
  }
}
