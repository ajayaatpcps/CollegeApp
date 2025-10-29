import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lbef/view_model/theme_provider.dart';
import 'package:provider/provider.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final List<Map<String, String>> bankAccounts = [
    {
      "bankName": "Prabhu Bank Ltd.",
      "accountName": "LBEF Vidyapeeth Pvt.Ltd.",
      "accountNumber": "0010154212400017",
      "branch": "Babar Mahal"
    },
    {
      "bankName": "NMB Bank",
      "accountName": "LBEF Vidyapeeth Pvt.Ltd.",
      "accountNumber": "0010016840500011",
      "branch": "Babar Mahal"
    },

  ];

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$text copied to clipboard")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Bank Accounts",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ...bankAccounts.map((acc) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: isDark ? Colors.black : Colors.white, // <-- Card background
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Bank: ${acc['bankName']}",
                              style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            ),
                            const SizedBox(height: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Account Name",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    Text(
                                      acc['accountName']!,
                                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.copy, size: 18, color: isDark ? Colors.white : Colors.grey),
                                      onPressed: () => copyToClipboard(acc['accountName']!),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Account Number",
                                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    Text(
                                      acc['accountNumber']!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.copy, size: 18, color: isDark ? Colors.white : Colors.grey),
                                      onPressed: () => copyToClipboard(acc['accountNumber']!),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              "Branch: ${acc['branch']}",
                              style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  Text(
                    "Payment Via Cheque",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Please issue the cheque in favor of \"LBEF Vidyapeeth Pvt. Ltd.\", "
                    "and write your (Student Name and College Roll No) at the back of the cheque",                  textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "We Accept FonePay",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: isDark ? Colors.white24 : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      "assets/images/qrImage.jpeg",
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Kindly, don’t forget to write your (Student Name) in the remarks section when making the payment.\n\n"
                        "Please contact Accounts Department at 01-4544356 (ext: 1052) or send a screenshot of the payment via WhatsApp at +977-9801110200 / +977-9801110600 for confirmation.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 50,)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
