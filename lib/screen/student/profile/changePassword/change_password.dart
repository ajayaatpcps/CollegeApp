import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/utils/utils.dart';
import 'package:lbef/widgets/form_widget/custom_button.dart';
import 'package:lbef/widgets/form_widget/custom_label_password.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/user_view_model/current_user_model.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // Define controllers for the password fields
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Basic password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    // Add more validation as needed (e.g., special characters, uppercase)
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(fontFamily: 'poppins', fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
          iconSize: 18,
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/lbef.png'),
            width: 70,
            height: 50,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 14),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              PasswordTextfield(
                text: 'Current Password',
                hintText: 'Enter your current password',
                outlinedColor: AppColors.primary,
                focusedColor: AppColors.primary,
                width: double.infinity,
                obscureText: true,
                textController: _currentPasswordController,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              PasswordTextfield(
                text: 'New Password',
                hintText: 'Enter your new password',
                outlinedColor: AppColors.primary,
                focusedColor: AppColors.primary,
                width: double.infinity,
                obscureText: true,
                textController: _newPasswordController,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              PasswordTextfield(
                text: 'Confirm New Password',
                hintText: 'Re-enter your new password',
                outlinedColor: AppColors.primary,
                focusedColor: AppColors.primary,
                width: double.infinity,
                obscureText: true,
                textController: _confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              Consumer<UserDataViewModel>(
                builder: (context, viewModel, child) => CustomButton(
                  text: 'Change Password',
                  onPressed: () async {
                    final currentPassword = _currentPasswordController.text;
                    final newPassword = _newPasswordController.text;
                    final confirmPassword = _confirmPasswordController.text;
                    if (currentPassword.isEmpty ||
                        newPassword.isEmpty ||
                        confirmPassword.isEmpty) {
                      Utils.flushBarErrorMessage(
                          'Please fill in all fields', context);
                      return;
                    }
                    final currentPasswordError =
                        _validatePassword(currentPassword);
                    final newPasswordError = _validatePassword(newPassword);
                    if (currentPasswordError != null ||
                        newPasswordError != null) {
                      Utils.flushBarErrorMessage(
                        currentPasswordError ??
                            newPasswordError ??
                            'Password validation failed',
                        context,
                      );
                      return;
                    }
                    if (newPassword != confirmPassword) {
                      Utils.flushBarErrorMessage(
                          'New passwords do not match', context);
                      return;
                    }

                    await viewModel.changePassword(
                      context,
                      {
                        "p1": currentPassword,
                        "p2": newPassword,
                      },
                    ).then((success) {
                      if (success) {
                        Utils.flushBarSuccessMessage(
                            'Password changed successfully', context);
                        _currentPasswordController.clear();
                        _newPasswordController.clear();
                        _confirmPasswordController.clear();
                      }
                    });
                  },
                  buttonColor: AppColors.primary,
                  isLoading: viewModel.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
