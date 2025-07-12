import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbef/screen/student/calender/calender_view_details.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:lbef/widgets/no_data/no_data_widget.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/status.dart';
import '../../../model/event_model.dart';
import '../../../view_model/calender/event_calender_view_model.dart';
import 'calender_widget.dart';
import 'display_dialog_calender.dart';
import 'shimmer_widget.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    final viewModel =
        Provider.of<EventCalenderViewModel>(context, listen: false);
    _fetchMonthlyEvents(viewModel, DateFormat('yyyy-MM').format(_focusedDay));
  }

  void _fetchMonthlyEvents(EventCalenderViewModel viewModel, String date) {
    print('Fetching events for month: $date'); // Debug log
    viewModel.fetchMonthly(
      'monthly',
      date,
      null,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventCalenderViewModel>(
      builder: (context, viewModel, child) {
        final selectedDateStr = DateFormat('yyyy-MM-dd').format(_selectedDay);
        final selectedDayEvents = viewModel.events
            .where((event) =>
                event.startDate != null &&
                DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(event.startDate!)) ==
                    selectedDateStr)
            .toList();


        return Scaffold(
          appBar: AppBar(
            title: const Text('Event Calendar'),
          ),
          body: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  final selectedMonth =
                      DateFormat('yyyy-MM').format(selectedDay);
                  if (selectedMonth !=
                      DateFormat('yyyy-MM').format(_focusedDay)) {
                    _fetchMonthlyEvents(viewModel, selectedMonth);
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  _fetchMonthlyEvents(
                    viewModel,
                    DateFormat('yyyy-MM').format(focusedDay),
                  );
                },
                eventLoader: (day) {
                  final dayStr = DateFormat('yyyy-MM-dd').format(day);
                  final events = viewModel.events
                      .where((event) =>
                          event.startDate != null &&
                          DateFormat('yyyy-MM-dd')
                                  .format(DateTime.parse(event.startDate!)) ==
                              dayStr)
                      .toList();

                  return events;
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: events.map((event) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1.0),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _parseColor(
                                  (event as EventModel).colorCode ?? 'grey'),
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return null;
                  },
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: viewModel.isLoading
                    ? const ShimmerWidget()
                    : viewModel.userData.status == Status.ERROR
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_month_outlined),
                                    Text(parseDate(_selectedDay.toString())),
                                  ],
                                ),
                              ),
                              BuildNoData(
                                MediaQuery.of(context).size,
                                "Error loading events",
                                Icons.error_outline,
                              ),
                            ],
                          )
                        : selectedDayEvents.isEmpty
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: Row(
                                      children: [
                                        const Icon(
                                            Icons.calendar_month_outlined),
                                        Text(
                                            parseDate(_selectedDay.toString())),
                                      ],
                                    ),
                                  ),
                                  BuildNoData(
                                    MediaQuery.of(context).size,
                                    "No event on the selected date!",
                                    Icons.calendar_month_outlined,
                                  ),
                                ],
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: selectedDayEvents.length,
                                itemBuilder: (context, index) {
                                  final event = selectedDayEvents[index];
                                  return InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            DisplayDialogCalender(
                                                id: event.eventId.toString() ??
                                                    '',
                                                text: 'Event Details',
                                                show:
                                                    const CalenderViewDetails()),
                                      );
                                    },
                                    child: CalenderWidget(
                                      title:
                                          event.eventName ?? 'Untitled Event',
                                      organizerName: event.organizerName ??
                                          'Unknown Organizer',
                                      date: event.eventType ?? 'No Type',
                                      color: _parseColor(
                                          event.colorCode ?? 'grey'),
                                      dateTime: event.startDate != null ||
                                              event.startDate != ''
                                          ? parseDate(event.startDate ?? '')
                                          : "", location:  event.location??'',
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _parseColor(String colorCode) {
    switch (colorCode.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
