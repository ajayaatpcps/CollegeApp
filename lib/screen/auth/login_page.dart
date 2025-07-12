import 'package:flutter/material.dart';
import 'package:lbef/screen/student/profile/recover_password/recover_password.dart';
import 'package:lbef/widgets/form_widget/role_selection.dart';
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
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                Container(
                  child: const Image(
                    image: AssetImage('assets/images/lbef.png'),
                    fit: BoxFit.contain,
                    width: 250,
                    height: 140,
                  ),
                ),
                if (isLoading) const LinearProgressIndicator(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
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
                                  onTap: () {
                                    Navigator.of(context).push(
                                      SlideRightRoute(
                                          page: const RecoverPassword()),
                                    );
                                  },
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
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (_studentIdController.text.isEmpty) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return Utils.flushBarErrorMessage(
                                        "Student Id is required.", context);
                                  }
                                  if (_passwordController.text.isEmpty) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return Utils.flushBarErrorMessage(
                                        "Password is required.", context);
                                  }

                                  await Provider.of<AuthViewModel>(context,
                                          listen: false)
                                      .login({
                                    "username": _studentIdController.text,
                                    "password": _passwordController.text
                                  }, context);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        '© 2025 LBEF. All Rights Reserved.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'poppins',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Designed, Built & Maintained by PCPS R&D',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
