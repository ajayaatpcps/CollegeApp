import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/utils/parse_date.dart';

class NoticeWidget extends StatelessWidget {
  final String published, body, subBody;

  const NoticeWidget({
    super.key,
    required this.subBody,
    required this.published,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.chrome_reader_mode_rounded,
                color: AppColors.primary,
                size: 30,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subBody,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: _shortenText(body, 12),
                          style: const TextStyle(fontSize: 12),
                          children: [
                            if (body.length > 150)
                              TextSpan(
                                text: '... View more',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      parseDate(published),
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              // const SizedBox(width: 8),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              //   decoration: BoxDecoration(
              //     color: AppColors.primary,
              //     borderRadius: BorderRadius.circular(5),
              //     border: Border.all(color: Colors.transparent),
              //   ),
              //   child: Text(
              //     published,
              //     style: const TextStyle(
              //       color: Colors.white,
              //       fontSize: 10,
              //     ),
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }

  String _shortenText(String text, int limit) {
    if (text.length <= limit) return text;
    return text.substring(0, limit);
  }
}
