import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

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
  late Animation<double> _logoAnimation;
  bool _obscurePassword = true;
  bool _isSignUp = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _logoAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final event = _isSignUp
          ? AuthSignUpRequested(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            )
          : AuthSignInRequested(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
      context.read<AuthBloc>().add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.5,
                colors: [
                  Color.fromRGBO(primaryColor.r.toInt(), primaryColor.g.toInt(),
                      primaryColor.b.toInt(), 0.8),
                  Color.fromRGBO(secondaryColor.r.toInt(),
                      secondaryColor.g.toInt(), secondaryColor.b.toInt(), 0.6),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color.fromRGBO(0, 0, 0, 0.2)
                            : const Color.fromRGBO(255, 255, 255, 0.2),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: isDarkMode
                              ? const Color.fromRGBO(255, 255, 255, 0.15)
                              : const Color.fromRGBO(158, 158, 158, 0.3),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo
                            ScaleTransition(
                              scale: _logoAnimation,
                              child: CircleAvatar(
                                radius: 48,
                                backgroundColor: primaryColor,
                                child: const Icon(
                                  Icons.chat_bubble_outline,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            // Title
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) =>
                                  SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.2),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              ),
                              child: Text(
                                _isSignUp ? 'Join the Chat' : 'Welcome Back',
                                key: ValueKey(_isSignUp),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32.0),
                            // Email Field
                            FadeTransition(
                              opacity: _logoAnimation,
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: secondaryColor,
                                  ),
                                  filled: true,
                                  fillColor: Color.fromRGBO(
                                      theme.colorScheme.surface.r.toInt(),
                                      theme.colorScheme.surface.g.toInt(),
                                      theme.colorScheme.surface.b.toInt(),
                                      0.8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  floatingLabelStyle:
                                      TextStyle(color: secondaryColor),
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
                              opacity: _logoAnimation,
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: secondaryColor,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: secondaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  filled: true,
                                  fillColor: Color.fromRGBO(
                                      theme.colorScheme.surface.r.toInt(),
                                      theme.colorScheme.surface.g.toInt(),
                                      theme.colorScheme.surface.b.toInt(),
                                      0.8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  floatingLabelStyle:
                                      TextStyle(color: secondaryColor),
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
                            if (!_isSignUp)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Forgot password not implemented yet',
                                                style: TextStyle(
                                                  color: theme.colorScheme
                                                      .onErrorContainer,
                                                ),
                                              ),
                                              backgroundColor: theme
                                                  .colorScheme.errorContainer,
                                            ),
                                          );
                                        },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 24.0),
                            // Submit Button
                            NeumorphicButton(
                              onPressed:
                                  isLoading ? null : () => _submit(context),
                              isDarkMode: isDarkMode,
                              primaryColor: primaryColor,
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: theme.colorScheme.onPrimary,
                                    )
                                  : Text(
                                      _isSignUp ? 'Sign Up' : 'Sign In',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: theme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 16.0),
                            // Toggle Mode
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _isSignUp = !_isSignUp;
                                      });
                                    },
                              child: Text(
                                _isSignUp
                                    ? 'Already have an account? Sign In'
                                    : 'Need an account? Sign Up',
                                style: TextStyle(
                                  color: secondaryColor,
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
