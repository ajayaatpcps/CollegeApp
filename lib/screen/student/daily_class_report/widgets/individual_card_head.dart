import 'package:flutter/material.dart';

class IndividualCardHead extends StatelessWidget {
  final String session,image,section, tutor, subject,code;
  const IndividualCardHead({super.key, required this.image, required this.tutor, required this.subject, required this.code, required this.session, required this.section});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return  Stack(
      children: [
        Container(
          width: size.width,
          height: 140,
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
                session,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                subject,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      "By $tutor",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      section,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
