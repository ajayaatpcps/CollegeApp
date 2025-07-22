import 'package:flutter/material.dart';

import '../../../../resource/colors.dart';

class ReportDetail extends StatelessWidget {
  final String head, value;
  final IconData icon;
  const ReportDetail({super.key, required this.head, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return  IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 50,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 30,
                    color: AppColors.primary,
                  ),

                ],
              ),
            ),
          ),
          Container(
            width: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 1,bottom:8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(15),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      head,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,

                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: const TextStyle( fontSize: 13),
                    ),

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}