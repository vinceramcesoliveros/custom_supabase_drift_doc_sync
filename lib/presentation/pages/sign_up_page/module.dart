import 'package:custom_supabase_drift_sync/domain/auth/sign_up_state.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/navigation/router.gr.dart';
import '../../module/module.dart';

part 'module.g.dart';

@riverpod
class SignUpP extends _$SignUpP {
  @override
  SignUpState build() {
    return const SignUpState();
  }

  void changeEmail(String email) {
    state = state.copyWith(email: email);
  }

  void changePassword(String password) {
    state = state.copyWith(password: password);
  }

  void signUp() async {
    if (!state.canSubmit) {
      state = state.copyWith(
          isFailure: true, errorMessage: 'Email and password are required');
      return;
    }
    state = state.copyWith(isSubmitting: true);

    try {
      final response = await Supabase.instance.client.auth
          .signUp(email: state.email, password: state.password);

      if (response.session != null) {
        ref
            .read(sessionPProvider.notifier)
            .setSession(Option.fromNullable(response.session));
        final appRouter = ref.read(appRouterProvider);
        await Future.delayed(const Duration(milliseconds: 500));
        appRouter.navigate(const HomeRoute());
      }
    } on AuthException catch (e) {
      state = state.copyWith(isFailure: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isFailure: true, errorMessage: e.toString());
    } finally {
      state = state.copyWith(isSubmitting: false, errorMessage: null);
    }
  }
}
