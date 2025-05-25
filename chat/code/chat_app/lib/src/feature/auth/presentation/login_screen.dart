import 'package:chat_app/src/feature/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;

  // Single animation controller for smooth transitions
  late AnimationController _transitionController;
  late AnimationController _initialController;

  // Animations
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<Color?> _accentColorAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Main transition controller for mode switching
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Initial animation controller for first load
    _initialController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Smooth slide animation with custom curve
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOutCubic,
    ));

    // Fade animation for smooth content transition
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // Gentle scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOutBack,
    ));

    // Start initial animation
    _initialController.forward();
    _transitionController.forward();
  }

  void _updateColorAnimations(ColorScheme colorScheme) {
    _backgroundColorAnimation = ColorTween(
      begin: _isLoginMode
          ? colorScheme.primaryContainer.withValues(alpha: 0.1)
          : colorScheme.secondaryContainer.withValues(alpha: 0.1),
      end: _isLoginMode
          ? colorScheme.secondaryContainer.withValues(alpha: 0.1)
          : colorScheme.primaryContainer.withValues(alpha: 0.1),
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));

    _accentColorAnimation = ColorTween(
      begin: _isLoginMode ? colorScheme.primary : colorScheme.secondary,
      end: _isLoginMode ? colorScheme.secondary : colorScheme.primary,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _transitionController.dispose();
    _initialController.dispose();
    super.dispose();
  }

  void _toggleMode() async {
    if (_transitionController.isAnimating) return; // Prevent multiple taps

    // Start the transition
    _transitionController.reverse().then((_) {
      setState(() {
        _isLoginMode = !_isLoginMode;
      });
      _transitionController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;
    final colorScheme = Theme.of(context).colorScheme;

    _updateColorAnimations(colorScheme);

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is AuthUnauthenticated) {
            Navigator.pushReplacementNamed(context, '/chat');
          }
        },
        child: AnimatedBuilder(
          animation: _transitionController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _backgroundColorAnimation.value ??
                        colorScheme.primaryContainer.withValues(alpha: 0.1),
                    colorScheme.surface,
                    (_backgroundColorAnimation.value ??
                        colorScheme.primaryContainer.withValues(alpha: 0.1)),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: isDesktop
                  ? _buildDesktopLayout(context, colorScheme)
                  : isTablet
                      ? _buildTabletLayout(context, colorScheme)
                      : _buildMobileLayout(context, colorScheme),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        // Left side - Image/Branding
        Expanded(
          flex: 6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.8),
                  colorScheme.primary,
                ],
              ),
            ),
            child: _buildBrandingSection(context, colorScheme),
          ),
        ),
        // Right side - Form
        Expanded(
          flex: 4,
          child: Container(
            color: colorScheme.surface,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: _buildForm(context, colorScheme),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        // Top - Branding (smaller)
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withOpacity(0.8),
                  colorScheme.primary,
                ],
              ),
            ),
            child: _buildBrandingSection(context, colorScheme, isCompact: true),
          ),
        ),
        // Bottom - Form
        Expanded(
          flex: 5,
          child: Container(
            color: colorScheme.surface,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: _buildForm(context, colorScheme),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, ColorScheme colorScheme) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Top branding section
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.8),
                    colorScheme.primary,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child:
                  _buildBrandingSection(context, colorScheme, isCompact: true),
            ),
            // Form section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildForm(context, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingSection(BuildContext context, ColorScheme colorScheme,
      {bool isCompact = false}) {
    return AnimatedBuilder(
      animation: _initialController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _initialController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _initialController,
              curve: Curves.easeOutCubic,
            )),
            child: Container(
              padding: EdgeInsets.all(isCompact ? 24.0 : 48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Chat app icon/illustration
                  Container(
                    width: isCompact ? 80 : 120,
                    height: isCompact ? 80 : 120,
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: isCompact ? 40 : 60,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: isCompact ? 16 : 24),
                  Text(
                    'ChatConnect',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: isCompact ? 28 : 36,
                        ),
                  ),
                  SizedBox(height: isCompact ? 8 : 16),
                  Text(
                    'Connect with friends and family\nthrough seamless conversations',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onPrimary.withValues(alpha: 0.9),
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _transitionController,
      builder: (context, child) {
        final currentAccentColor = _accentColorAnimation.value ??
            (_isLoginMode ? colorScheme.primary : colorScheme.secondary);

        return ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: currentAccentColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: currentAccentColor.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.05),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mode indicator with smooth transition
                    _buildModeSelector(
                        context, colorScheme, currentAccentColor),
                    const SizedBox(height: 32),

                    // Welcome text with animated transitions
                    _buildWelcomeText(context, currentAccentColor, colorScheme),
                    const SizedBox(height: 32),

                    // Email field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      colorScheme: colorScheme,
                      accentColor: currentAccentColor,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      colorScheme: colorScheme,
                      accentColor: currentAccentColor,
                    ),
                    const SizedBox(height: 32),

                    // Submit button
                    _buildSubmitButton(
                        context, currentAccentColor, colorScheme),

                    if (_isLoginMode) ...[
                      const SizedBox(height: 16),
                      AnimatedOpacity(
                        opacity: _fadeAnimation.value,
                        duration: const Duration(milliseconds: 300),
                        child: TextButton(
                          onPressed: () {
                            // Handle forgot password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: currentAccentColor),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeSelector(
      BuildContext context, ColorScheme colorScheme, Color currentAccentColor) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildModeTab(
              context,
              'Login',
              _isLoginMode,
              colorScheme.primary,
              () => _isLoginMode ? null : _toggleMode(),
            ),
          ),
          Expanded(
            child: _buildModeTab(
              context,
              'Sign Up',
              !_isLoginMode,
              colorScheme.secondary,
              () => !_isLoginMode ? null : _toggleMode(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText(
      BuildContext context, Color currentAccentColor, ColorScheme colorScheme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey<bool>(_isLoginMode),
        children: [
          Text(
            _isLoginMode ? 'Welcome Back!' : 'Create Account',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: currentAccentColor,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _isLoginMode
                ? 'Sign in to continue your conversations'
                : 'Join us to start connecting with others',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab(BuildContext context, String title, bool isActive,
      Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isActive
                        ? Colors.white
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ) ??
              const TextStyle(),
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
    required Color accentColor,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: accentColor.withValues(alpha: 0.7)),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: accentColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: accentColor,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(color: accentColor.withValues(alpha: 0.8)),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, Color accentColor, ColorScheme colorScheme) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: colorScheme.onPrimary,
              elevation: 8,
              shadowColor: accentColor.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              disabledBackgroundColor: accentColor.withValues(alpha: 0.5),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      _isLoginMode ? 'Sign In' : 'Create Account',
                      key: ValueKey<bool>(_isLoginMode),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _handleSubmit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
          _isLoginMode
              ? AuthSignInRequested(email, password)
              : AuthSignUpRequested(email, password),
        );
  }
}
