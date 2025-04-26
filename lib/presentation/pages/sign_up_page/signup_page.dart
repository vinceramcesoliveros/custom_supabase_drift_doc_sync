import 'package:auto_route/auto_route.dart';
import 'package:custom_supabase_drift_sync/core/navigation/router.gr.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:custom_supabase_drift_sync/presentation/pages/sign_up_page/module.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants.dart';

@RoutePage()
class SignupPage extends HookConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpNot = ref.watch(signUpPProvider.notifier);
    final signUpState = ref.watch(signUpPProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text("PowerSync Flutter Demo"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Sign Up'),
                      const SizedBox(height: 35),
                      TextFormField(
                        onChanged: signUpNot.changeEmail,
                        decoration: const InputDecoration(labelText: "Email"),
                        enabled: !signUpState.isSubmitting,
                        onFieldSubmitted: signUpState.isSubmitting
                            ? null
                            : (String value) {
                                signUpNot.signUp();
                              },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: signUpNot.changePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            errorText: signUpState.errorMessage),
                        enabled: !signUpState.isSubmitting,
                        onFieldSubmitted: signUpState.isSubmitting
                            ? null
                            : (String value) {
                                signUpNot.signUp();
                              },
                      ),
                      const SizedBox(height: 25),
                      TextButton(
                        onPressed: signUpState.isSubmitting
                            ? null
                            : () {
                                signUpNot.signUp();
                              },
                        child: const Text('Sign Up'),
                      ),
                      const Gap(K.spacing24),
                      TextButton(
                        onPressed: signUpState.isSubmitting
                            ? null
                            : () {
                                ref
                                    .read(appRouterProvider)
                                    .navigate(const LoginRoute());
                              },
                        child: const Text('Already have an account? Sign In'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
