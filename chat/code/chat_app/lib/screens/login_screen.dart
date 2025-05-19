import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat App')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          bool isSignUp = state is AuthUnauthenticated && state.isSignUp;
          bool isLoading = state is AuthLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          if (email.isNotEmpty && password.isNotEmpty) {
                            if (isSignUp) {
                              context.read<AuthBloc>().add(
                                    AuthSignUp(
                                        email: email, password: password),
                                  );
                            } else {
                              context.read<AuthBloc>().add(
                                    AuthSignIn(
                                        email: email, password: password),
                                  );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill all fields')),
                            );
                          }
                        },
                  child: Text(isLoading
                      ? 'Loading...'
                      : isSignUp
                          ? 'Sign Up'
                          : 'Sign In'),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<AuthBloc>().add(AuthToggleMode());
                        },
                  child: Text(isSignUp
                      ? 'Already have an account? Sign In'
                      : 'No account? Sign Up'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
