import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:shimmer/shimmer.dart';

class ViewProfileShimmer extends StatelessWidget {
  const ViewProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Shimmer for profile image
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    period: const Duration(milliseconds: 1200),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Shimmer for name and details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        period: const Duration(milliseconds: 1200),
                        child: Container(
                          width: size.width * 0.6,
                          height: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        period: const Duration(milliseconds: 1200),
                        child: Container(
                          width: size.width * 0.5,
                          height: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        period: const Duration(milliseconds: 1200),
                        child: Container(
                          width: size.width * 0.4,
                          height: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Shimmer for section headers
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1200),
            child: Container(
              width: 200,
              height: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          // Shimmer for info rows
          ...List.generate(6, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.primary,
                    highlightColor: Colors.blue[200]!,
                    period: const Duration(milliseconds: 1200),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          period: const Duration(milliseconds: 1200),
                          child: Container(
                            width: size.width * 0.4,
                            height: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          period: const Duration(milliseconds: 1200),
                          child: Container(
                            width: size.width * 0.5,
                            height: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          // Shimmer for Guardian Information section
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1200),
            child: Container(
              width: 200,
              height: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.primary,
                    highlightColor: Colors.blue[200]!,
                    period: const Duration(milliseconds: 1200),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          period: const Duration(milliseconds: 1200),
                          child: Container(
                            width: size.width * 0.4,
                            height: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          period: const Duration(milliseconds: 1200),
                          child: Container(
                            width: size.width * 0.5,
                            height: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          // Shimmer for Academic Information section
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1200),
            child: Container(
              width: 200,
              height: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(6, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.primary,
                    highlightColor: Colors.blue[200]!,
                    period: const Duration(milliseconds: 1200),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          period: const Duration(milliseconds: 1200),
                          child: Container(
                            width: size.width * 0.4,
                            height: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          period: const Duration(milliseconds: 1200),
                          child: Container(
                            width: size.width * 0.5,
                            height: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          // Shimmer for Subjects section
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1200),
            child: Container(
              width: 200,
              height: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                period: const Duration(milliseconds: 1200),
                child: Container(
                  width: size.width * 0.7,
                  height: 14,
                  color: Colors.white,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}