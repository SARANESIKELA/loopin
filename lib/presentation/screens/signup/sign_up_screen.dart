import 'package:flutter/material.dart';
import 'package:loopin/core/constants/app_theme.dart';
import 'package:loopin/presentation/widgets/custom_text_field.dart';
import 'package:loopin/presentation/widgets/gradient_button.dart';
import 'package:loopin/presentation/widgets/loading_dots_animation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _gender = 'Male';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ScaffoldBackGroundColor,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.Black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.Black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Enter Your name';
                          return null;
                        },
                      ),

                      verticalSpace(12),

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

                      verticalSpace(12),
                      Row(
                        children: [
                          const Text('Gender: '),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: const Text('Male'),
                                    value: 'Male',
                                    groupValue: _gender,
                                    activeColor: Colors
                                        .black, // ✅ Selected color set to black
                                    onChanged: (v) =>
                                        setState(() => _gender = v!),
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: const Text('Female'),
                                    value: 'Female',
                                    groupValue: _gender,
                                    activeColor: Colors
                                        .black, // ✅ Selected color set to black
                                    onChanged: (v) =>
                                        setState(() => _gender = v!),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      verticalSpace(16),

                      SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          onPressed: _isLoading ? () {} : _onSignUp,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  child: LoadingDots(size: 8, spacing: 6),
                                )
                              : const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      verticalSpace(12),

                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back, // back arrow icon
                          color: AppTheme.Black, // black color
                          size: 20, // slightly smaller for balance
                        ),
                        label: const Text(
                          'Back to Login',
                          style: TextStyle(
                            color: AppTheme.Black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.Black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
