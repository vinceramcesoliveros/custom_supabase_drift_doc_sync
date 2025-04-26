import 'package:auto_route/auto_route.dart';
import 'package:custom_supabase_drift_sync/core/navigation/router.gr.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:custom_supabase_drift_sync/presentation/pages/login_page/module.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInNot = ref.watch(signInPProvider.notifier);
    final signInState = ref.watch(signInPProvider);
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
                      const Text('Supabase Login'),
                      const SizedBox(height: 35),
                      TextFormField(
                        onChanged: signInNot.changeEmail,
                        decoration: const InputDecoration(labelText: "Email"),
                        enabled: !signInState.isSubmitting,
                        onFieldSubmitted: signInState.isSubmitting
                            ? null
                            : (String value) {
                                signInNot.signIn();
                              },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: signInNot.changePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            errorText: signInState.errorMessage),
                        enabled: !signInState.isSubmitting,
                        onFieldSubmitted: signInState.isSubmitting
                            ? null
                            : (String value) {
                                signInNot.signIn();
                              },
                      ),
                      const SizedBox(height: 25),
                      TextButton(
                        onPressed: signInState.isSubmitting
                            ? null
                            : () {
                                signInNot.signIn();
                              },
                        child: const Text('Login'),
                      ),
                      TextButton(
                        onPressed: signInState.isSubmitting
                            ? null
                            : () {
                                ref
                                    .read(appRouterProvider)
                                    .navigate(const SignupRoute());
                              },
                        child: const Text('Sign Up'),
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
