import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/view_model/user_view_model/auth_view_model.dart';
import 'package:lbef/widgets/form_widget/custom_button.dart';
import 'package:lbef/widgets/form_widget/custom_label_textfield.dart';
import 'package:provider/provider.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final _rollController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  void dispose() {
    _rollController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Function to show date picker and update DOB controller
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.light(primary: AppColors.primary),
          buttonTheme:
              const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      // Format date as DD/MM/YYYY for display
      String displayDate = "${picked.day.toString().padLeft(2, '0')}/"
          "${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      _dobController.text = displayDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recover Password",
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
              CustomLabelTextfield(
                text: 'Student Roll number',
                hintText: 'Enter your roll number',
                outlinedColor: AppColors.primary,
                focusedColor: AppColors.primary,
                width: double.infinity,
                obscureText: false,
                textController: _rollController,
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              CustomLabelTextfield(
                text: 'Personal Email',
                hintText: 'Enter your personal email',
                outlinedColor: AppColors.primary,
                focusedColor: AppColors.primary,
                width: double.infinity,
                obscureText: false,
                textController: _emailController,
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    "Date of Birth",
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _dobController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: 'Enter your date of birth',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Consumer<AuthViewModel>(
                builder: (context, viewModel, child) => CustomButton(
                  text: 'Recover Password',
                  onPressed: () {
                    if (_rollController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _dobController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in all fields')),
                      );
                      return;
                    }
                    String dob = _dobController.text;
                    if (dob.isNotEmpty) {
                      List<String> parts = dob.split('/');
                      dob = '${parts[2]}-${parts[1]}-${parts[0]}';
                    }
                    viewModel.recover(
                      context,
                      {
                        "p1": _rollController.text,
                        "p2": _emailController.text,
                        "p3": dob,
                      },
                    );
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
