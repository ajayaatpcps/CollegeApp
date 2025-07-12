import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/screen/student/profile/profile_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../constant/base_url.dart';
import '../../../view_model/user_view_model/current_user_model.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

// ... keep your imports and class declaration

class _ViewProfilePageState extends State<ViewProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account', style: TextStyle(fontFamily: 'Poppins')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Image(
              image: AssetImage('assets/images/lbef.png'),
              width: 70,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<UserDataViewModel>(
          builder: (context, viewModel, _) {
            final user = viewModel.currentUser;

            if (user == null) return const ViewProfileShimmer();

            final image =
                "${BaseUrl.imageDisplay}/html/profiles/students/${user.stuProfilePath}/${user.stuPhoto}";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: NetworkImage(image),
                        onBackgroundImageError: (_, __) =>
                            const Icon(Icons.school, size: 60),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${user.stuFirstname ?? ''} ${user.stuLastname ?? ''}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('${user.courseShortName} ${user.semesterName ?? ''}',
                          style: const TextStyle(fontSize: 16)),
                      Text(user.stuRollNo ?? '',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _sectionHeader(Icons.info, 'Personal Information'),
                _buildInfoRow(Icons.person, 'Full Name:',
                    '${user.stuFirstname ?? ''} ${user.stuMiddlename ?? ''} ${user.stuLastname ?? ''}'),
                _buildInfoRow(Icons.male, 'Gender:', user.stuGender ?? ''),
                _buildInfoRow(Icons.phone, 'Mobile:', user.stuMobile ?? ''),
                _buildInfoRow(Icons.email, 'Email:', user.stuEmail ?? ''),
                _buildInfoRow(
                    Icons.location_city, 'City:', user.stuResCity ?? ''),
                _buildInfoRow(Icons.flag, 'Country:', user.stuResCountry ?? ''),
                _buildInfoRow(
                    Icons.verified_user, 'Status:', user.studentStatus ?? ''),
                const SizedBox(height: 20),
                _sectionHeader(Icons.group, 'Guardian Information'),
                _buildInfoRow(
                    Icons.person, 'Father Name:', user.stuFatherName ?? ''),
                _buildInfoRow(
                    Icons.person, 'Mother Name:', user.stuMotherName ?? ''),
                _buildInfoRow(
                    Icons.person, 'Guardian Name:', user.stuGurName ?? ''),
                _buildInfoRow(
                    Icons.phone, 'Guardian Mobile:', user.stuGurMobile ?? ''),
                _buildInfoRow(
                    Icons.email, 'Guardian Email:', user.stuGurEmail ?? ''),
                const SizedBox(height: 20),
                _sectionHeader(Icons.school, 'Academic Information'),
                _buildInfoRow(Icons.book, 'Course:', user.courseName ?? ''),
                _buildInfoRow(Icons.badge, 'College ID:', user.stuRollNo ?? ''),
                _buildInfoRow(
                    Icons.date_range, 'Session:', user.sessionName ?? ''),
                _buildInfoRow(Icons.confirmation_number, 'Univ Roll No:',
                    user.stuUnivRollNo ?? ''),
                _buildInfoRow(
                    Icons.timeline, 'Semester:', user.semesterName ?? ''),
                _buildInfoRow(Icons.wifi, 'Wi-Fi Access:',
                    user.stuWifiAccess ?? 'Not provided'),
                const SizedBox(height: 20),
                _sectionHeader(Icons.menu_book, 'Current Subjects'),
                ...user.subjects?.map((subject) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.book,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${subject.subjectName} (${subject.subjectCode})',
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        )) ??
                    [const Text('No subjects available')],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Divider(thickness: 1, height: 16),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label ',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
