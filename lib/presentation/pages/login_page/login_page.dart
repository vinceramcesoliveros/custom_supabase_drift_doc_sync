import 'package:auto_route/auto_route.dart';
import 'package:custom_supabase_drift_sync/core/extensions/context_extension.dart';
import 'package:custom_supabase_drift_sync/core/navigation/router.gr.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:custom_supabase_drift_sync/presentation/pages/login_page/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
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
                      const Gap(16),
                      _TestAccountInfoWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class _TestAccountInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const email = 'testaccount2@gmail.com';
    const password = 'testaccount2@gmail.com';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: const [
                TextSpan(
                  text: 'Don\'t want to create an account to test it?\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: 'Use this account:\n\n'),
              ],
            ),
          ),
          const Gap(4),
          const _CopyableCredentialRow(label: 'Email', value: email),
          const Gap(8),
          const _CopyableCredentialRow(label: 'Password', value: password),
        ],
      ),
    );
  }
}

class _CopyableCredentialRow extends StatelessWidget {
  final String label;
  final String value;

  const _CopyableCredentialRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
        IconButton(
          constraints: const BoxConstraints(maxHeight: 32, minWidth: 32),
          padding: EdgeInsets.zero,
          iconSize: 18,
          icon: const Icon(Icons.copy),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: value));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$label copied to clipboard'),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }
}
