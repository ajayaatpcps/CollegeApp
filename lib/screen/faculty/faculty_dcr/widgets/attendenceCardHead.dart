import 'package:flutter/material.dart';

class AttendenceCardHead extends StatelessWidget {
  final String className,subject,image,classDate, time;
  const AttendenceCardHead({super.key, required this.className, required this.image, required this.classDate, required this.time, required this.subject, });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return  Stack(
      children: [
        Container(
          width: size.width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child:ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Image.asset(
              'assets/images/mountain.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 10,
          bottom: 10,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Text(
                className,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 240,
                    child: Text(
                      classDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
