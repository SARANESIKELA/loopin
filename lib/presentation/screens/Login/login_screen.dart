import 'package:flutter/material.dart';
import 'package:loopin/core/constants/app_theme.dart';
import 'package:loopin/presentation/widgets/custom_text_field.dart';
import 'package:loopin/presentation/widgets/gradient_button.dart';
import 'package:loopin/presentation/screens/feed/feed_screen.dart';
import 'package:loopin/presentation/screens/forgot_password/forgot_password.dart';
import 'package:loopin/presentation/screens/signup/sign_up_screen.dart';
import 'package:loopin/presentation/widgets/loading_dots_animation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FeedScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.ScaffoldBackGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 28),

              // Top branding area
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.BoxColor1, AppTheme.BoxColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.Black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.white,
                        child: Image.asset(
                          'assets/images/logo_bg_remover.png',
                          height: 70,
                          width: 70,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Sign in to continue to your account',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.Black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              verticalSpace(32),

              // Card with form
              Container(
                width: width,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.Black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Enter email';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
                            return 'Enter valid email';
                          return null;
                        },
                      ),

                      verticalSpace(12),

                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Enter password';
                          if (v.trim().length < 4) return 'Password too short';
                          return null;
                        },
                      ),

                      // verticalSpace(4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: AppTheme.Black, // black color
                              fontSize: 16, // comfortable readable size
                              fontWeight:
                                  FontWeight.w600, // semi-bold for emphasis
                              letterSpacing: 0.5, // subtle spacing for polish
                            ),
                          ),
                        ),
                      ),

                      verticalSpace(16),

                      // Login button (shows LoadingDots inside the GradientButton while loading)
                      SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          onPressed: _isLoading ? () {} : _onLogin,
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  child: LoadingDots(size: 8, spacing: 6),
                                )
                              : const Text('Login'),
                        ),
                      ),

                      verticalSpace(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? "),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding:
                                  EdgeInsets.zero, // removes default padding
                              minimumSize: Size(0, 0), // ensures compact layout
                              tapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // keeps button tight
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppTheme.Black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              verticalSpace(16),

              // Small footer
              const Text(
                'By continuing you agree to our Terms & Privacy',
                style: TextStyle(fontSize: 12, color: AppTheme.Black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
