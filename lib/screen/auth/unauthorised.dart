import 'package:flutter/material.dart';

import '../../resource/colors.dart';

class UnauthorisedPage extends StatefulWidget {
  const UnauthorisedPage({super.key});

  @override
  State<UnauthorisedPage> createState() => _UnauthorisedPageState();
}

class _UnauthorisedPageState extends State<UnauthorisedPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Oops....",
          style: TextStyle(fontFamily: 'poppins-black', color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 18,
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/lbef.png'),
            width: 56,
            height: 24,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 18,
          )
        ],
      ),
      body: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              "404",
              style: TextStyle(
                  fontSize: 55,
                  color: AppColors.primary,
                  fontFamily: 'poppins-semi'),
            ),
            Text(
              "Page Not Found!",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'poppins-black',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "We apologize, but the page you are looking for is not available. This page is exclusively accessible to students, and is not intended for higher authorities, librarians, or staff members.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: AppColors.primary, size: 100),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                minimumSize: const MaterialStatePropertyAll(
                  Size(double.infinity, 50),
                ),
                backgroundColor: MaterialStatePropertyAll(AppColors.primary),
                shape: const MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
              child: const Text(
                'Go Back',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
