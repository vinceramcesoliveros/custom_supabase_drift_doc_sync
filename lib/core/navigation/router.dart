import 'package:auto_route/auto_route.dart';
import 'package:custom_supabase_drift_sync/core/navigation/router.gr.dart';
import 'package:custom_supabase_drift_sync/core/navigation/utils/navigation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({
    required this.ref,
  });

  final Ref ref;
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: SignupRoute.page),
        AutoRoute(
          path: "/",
          page: HomeRoute.page,
          guards: [AuthGuard(ref: ref)],
        ),
        AutoRoute(
          page: ProjectRoute.page,
          guards: [AuthGuard(ref: ref)],
        ),
        AutoRoute(
          page: TaskRoute.page,
          guards: [AuthGuard(ref: ref)],
        ),
        AutoRoute(
          page: DocRoute.page,
          guards: [AuthGuard(ref: ref)],
        ),
      ];
}
