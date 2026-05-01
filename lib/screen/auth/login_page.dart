import 'package:flutter/material.dart';
import 'package:lbef/screen/student/profile/recover_password/recover_password.dart';
import 'package:lbef/services/biometric_service.dart';
import 'package:provider/provider.dart';
import '../../resource/colors.dart';
import '../../utils/navigate_to.dart';
import '../../utils/utils.dart';
import '../../view_model/user_view_model/auth_view_model.dart';
import '../../widgets/form_widget/custom_button.dart';
import '../../widgets/form_widget/custom_label_password.dart';
import '../../widgets/form_widget/custom_label_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  bool _biometricAvailable = false;
  bool _biometricSetup = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometric() async {
    final available = await BiometricService.isAvailable();
    final setup = await BiometricService.isSetup();
    if (mounted) {
      setState(() {
        _biometricAvailable = available;
        _biometricSetup = setup;
      });
    }
  }

  Future<void> _loginWithBiometric() async {
    setState(() => isLoading = true);
    final success = await Provider.of<AuthViewModel>(context, listen: false)
        .loginWithBiometric(context);
    if (mounted) {
      setState(() => isLoading = false);
      // AuthViewModel shows its own error messages.
      // OS biometric UI shows its own failure UI.
      // Nothing extra needed here.
    }
  }

  /// Shows the "Enable Fingerprint?" bottom sheet.
  ///
  /// THE KEY FIX: We capture the outer page's BuildContext into a local
  /// variable BEFORE the sheet is shown. The sheet's own builder receives
  /// a different [sheetContext] which becomes invalid after pop().
  /// All calls to Provider and Utils use [pageContext], never [sheetContext].
  void _promptBiometricSetup() {
    // Capture page context NOW, before any async gap or navigation.
    final pageContext = context;

    showModalBottomSheet(
      context: pageContext,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(Icons.fingerprint, size: 60, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text(
              'Enable Fingerprint Login?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Skip entering your password next time.\nUse your fingerprint to log in instantly.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Not Now'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // 1. Close the bottom sheet first using sheetContext
                      Navigator.of(sheetContext).pop();
                      // 2. Then run setup using the CAPTURED pageContext,
                      //    NOT sheetContext (which is now invalid after pop).
                      //    We schedule it after the current frame so the sheet
                      //    animation has time to complete cleanly.
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _setupBiometric(pageContext);
                      });
                    },
                    child: const Text('Enable'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Calls GET /api/biometrics via AuthViewModel and saves the returned token.
  /// Takes an explicit [ctx] parameter so it never relies on `this.context`
  /// after an async gap, avoiding the "widget has been unmounted" crash.
  Future<void> _setupBiometric(BuildContext ctx) async {
    // Guard: if the page itself was somehow disposed, do nothing.
    if (!mounted) return;

    final success =
    await Provider.of<AuthViewModel>(ctx, listen: false)
        .setupBiometric(ctx);

    // Guard again after the await.
    if (!mounted) return;

    if (success) {
      setState(() => _biometricSetup = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fingerprint login enabled!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // AuthViewModel already shows an error snackbar on failure,
      // so nothing extra needed here.
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 30),
                const Image(
                  image: AssetImage('assets/images/pcpsLogo.png'),
                  fit: BoxFit.contain,
                  width: 250,
                  height: 140,
                ),
                if (isLoading)
                  const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Sign in",
                        style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Hi there! Nice to see you again.",
                        style: TextStyle(fontFamily: 'poppins', fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomLabelTextfield(
                          textController: _studentIdController,
                          hintText: "Student Id",
                          outlinedColor: Colors.grey,
                          focusedColor: AppColors.primary,
                          width: size.width,
                          helperStyle: const TextStyle(
                            color: Colors.red,
                            fontFamily: 'poppins',
                            fontStyle: FontStyle.italic,
                          ),
                          text: "Student Id",
                        ),
                        const SizedBox(height: 14),
                        PasswordTextfield(
                          textController: _passwordController,
                          hintText: "Password",
                          obscureText: true,
                          outlinedColor: Colors.grey,
                          focusedColor: AppColors.primary,
                          width: size.width,
                          helperStyle: const TextStyle(
                            color: Colors.red,
                            fontFamily: 'poppins',
                            fontStyle: FontStyle.italic,
                          ),
                          text: "Password",
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).push(
                                SlideRightRoute(page: const RecoverPassword()),
                              ),
                              child: const Text(
                                "Recover Password",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        CustomButton(
                          isLoading: isLoading,
                          text: "Sign in",
                          onPressed: () async {
                            if (_studentIdController.text.trim().isEmpty) {
                              return Utils.flushBarErrorMessage(
                                  "Student Id is required.", context);
                            }
                            if (_passwordController.text.isEmpty) {
                              return Utils.flushBarErrorMessage(
                                  "Password is required.", context);
                            }

                            setState(() => isLoading = true);

                            await Provider.of<AuthViewModel>(context,
                                listen: false)
                                .login({
                              "username": _studentIdController.text.trim(),
                              "password": _passwordController.text,
                            }, context);

                            setState(() => isLoading = false);

                            // Prompt biometric setup only if:
                            // • widget is still mounted
                            // • device supports biometrics
                            // • biometric not yet configured
                            if (mounted &&
                                _biometricAvailable &&
                                !_biometricSetup) {
                              _promptBiometricSetup();
                            }
                          },
                        ),

                        // Fingerprint button — only visible when already set up
                        if (_biometricAvailable && _biometricSetup) ...[
                          const SizedBox(height: 24),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 12),
                                child: Text('or',
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: isLoading
                                      ? null
                                      : _loginWithBiometric,
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.primary,
                                          width: 2),
                                      borderRadius:
                                      BorderRadius.circular(60),
                                    ),
                                    child: Icon(
                                      Icons.fingerprint,
                                      size: 52,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Login with Fingerprint',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'poppins',
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        '© ${DateTime.now().year} PCPS. All Rights Reserved.',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'poppins'),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Designed, Built & Maintained by YakshaSoft',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'poppins'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}