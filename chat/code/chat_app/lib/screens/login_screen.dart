import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<Color?> _gradientAnimation;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _gradientAnimation = ColorTween(
      begin: Colors.teal[300],
      end: Colors.purple[300],
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, bool isSignUp) {
    if (_formKey.currentState!.validate()) {
      final event = isSignUp
          ? AuthSignUp(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            )
          : AuthSignIn(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
      context.read<AuthBloc>().add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Colors.teal[200]! : Colors.teal[600]!;
    final accentColor = isDarkMode ? Colors.purple[200]! : Colors.purple[600]!;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red[700],
              ),
            );
          }
        },
        builder: (context, state) {
          final isSignUp = state is AuthUnauthenticated && state.isSignUp;
          final isLoading = state is AuthLoading;

          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _gradientAnimation.value ?? primaryColor,
                      accentColor,
                    ],
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color.fromRGBO(33, 33, 33, 0.3)
                                : const Color.fromRGBO(255, 255, 255, 0.3),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: isDarkMode
                                  ? const Color.fromRGBO(255, 255, 255, 0.2)
                                  : const Color.fromRGBO(158, 158, 158, 0.5),
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Logo Placeholder
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: primaryColor,
                                  child: const Icon(
                                    Icons.chat_bubble,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                // Title
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    isSignUp ? 'Create Account' : 'Sign In',
                                    key: ValueKey(isSignUp),
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.grey[800],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24.0),
                                // Email Field
                                FadeTransition(
                                  opacity: Tween<double>(begin: 0.5, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(0.0, 0.5,
                                          curve: Curves.easeInOut),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email,
                                          color: primaryColor),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 16.0),
                                      filled: true,
                                      fillColor: isDarkMode
                                          ? const Color.fromRGBO(0, 0, 0, 0.2)
                                          : const Color.fromRGBO(
                                              255, 255, 255, 0.7),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    enabled: !isLoading,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                // Password Field
                                FadeTransition(
                                  opacity: Tween<double>(begin: 0.5, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(0.5, 1.0,
                                          curve: Curves.easeInOut),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon:
                                          Icon(Icons.lock, color: primaryColor),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: primaryColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 16.0),
                                      filled: true,
                                      fillColor: isDarkMode
                                          ? const Color.fromRGBO(0, 0, 0, 0.2)
                                          : const Color.fromRGBO(
                                              255, 255, 255, 0.7),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    obscureText: _obscurePassword,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                    enabled: !isLoading,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                // Forgot Password
                                if (!isSignUp)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Forgot password not implemented yet'),
                                                ),
                                              );
                                            },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(color: accentColor),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 24.0),
                                // Submit Button
                                NeumorphicButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _submit(context, isSignUp),
                                  isDarkMode: isDarkMode,
                                  primaryColor: primaryColor,
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          isSignUp ? 'Sign Up' : 'Sign In',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 16.0),
                                // Toggle Mode
                                TextButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => context
                                          .read<AuthBloc>()
                                          .add(AuthToggleMode()),
                                  child: Text(
                                    isSignUp
                                        ? 'Have an account? Sign In'
                                        : 'Need an account? Sign Up',
                                    style: TextStyle(
                                      color: accentColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Neumorphic Button Widget
class NeumorphicButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isDarkMode;
  final Color primaryColor;

  const NeumorphicButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.isDarkMode,
    required this.primaryColor,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int red = widget.primaryColor.r.toInt();
    final int green = widget.primaryColor.g.toInt();
    final int blue = widget.primaryColor.b.toInt();
    final double opacity1 =
        widget.isDarkMode ? (_isPressed ? 0.7 : 0.9) : (_isPressed ? 0.8 : 1.0);
    final double opacity2 =
        widget.isDarkMode ? (_isPressed ? 0.5 : 0.7) : (_isPressed ? 0.6 : 0.8);

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(red, green, blue, opacity1),
              Color.fromRGBO(red, green, blue, opacity2),
            ],
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color:
                        Color.fromRGBO(0, 0, 0, widget.isDarkMode ? 0.3 : 0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(
                        255, 255, 255, widget.isDarkMode ? 0.05 : 0.5),
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
