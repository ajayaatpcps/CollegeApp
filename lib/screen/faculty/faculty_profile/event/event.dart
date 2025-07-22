import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/screen/student/profile/event/widgets/event_card.dart';

class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  final List<Map<String, String>> events = [
    {
      'title': 'LBEF PRESENTS BLOOD DONATION PROGRAM',
      'dateTime': 'Wed, Apr 28 • 5:30 PM',
      'location': 'LBEF Campus, Maitidevi',
    },
    {
      'title': 'International Band Music Concert',
      'dateTime': 'Wed, Apr 28 • 5:30 PM',
      'location': 'LBEF Campus, Maitidevi',
    },
    {
      'title': 'LBEF PRESENTS BLOOD DONATION PROGRAM',
      'dateTime': 'Wed, Apr 28 • 5:30 PM',
      'location': 'LBEF Campus, Maitidevi',
    },
    {
      'title': 'LBEF PRESENTS BLOOD DONATION PROGRAM',
      'dateTime': 'Wed, Apr 28 • 5:30 PM',
      'location': 'LBEF Campus, Maitidevi',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Event",
          style: TextStyle(fontFamily: 'poppins'),
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
            image: AssetImage('assets/images/pcpsLogo.png'),
            width: 56,
            height: 50,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header

            // Event List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(
                    title: event['title']!,
                    dateTime: event['dateTime']!,
                    location: event['location']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
