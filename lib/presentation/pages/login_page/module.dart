import 'package:custom_supabase_drift_sync/domain/auth/sign_in_state.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'module.g.dart';

@riverpod
class SignInP extends _$SignInP {
  @override
  SignInState build() {
    return const SignInState();
  }

  void changeEmail(String email) {
    state = state.copyWith(email: email);
  }

  void changePassword(String password) {
    state = state.copyWith(password: password);
  }

  void signIn() async {
    if (!state.canSubmit) {
      state = state.copyWith(
          isFailure: true, errorMessage: 'Email and password are required');
      return;
    }
    state = state.copyWith(isSubmitting: true);

    try {
      final response = await Supabase.instance.client.auth
          .signInWithPassword(email: state.email, password: state.password);

      if (response.session != null) {
        ref
            .read(sessionPProvider.notifier)
            .setSession(Option.fromNullable(response.session));
      }
    } on AuthException catch (e) {
      state = state.copyWith(isFailure: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isFailure: true, errorMessage: e.toString());
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
