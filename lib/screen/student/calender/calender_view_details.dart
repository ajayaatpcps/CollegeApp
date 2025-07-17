import 'package:flutter/material.dart';
import 'package:lbef/utils/format_time.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:provider/provider.dart';

import '../../../view_model/calender/event_calender_view_model.dart';
import '../../../widgets/no_data/no_data_widget.dart';

class CalenderViewDetails extends StatefulWidget {
  const CalenderViewDetails({super.key});

  @override
  State<CalenderViewDetails> createState() => _CalenderViewDetailsState();
}

class _CalenderViewDetailsState extends State<CalenderViewDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventCalenderViewModel>(
      builder: (context, viewModel, child) {
        final event = viewModel.currentDetails;

        if (viewModel.isLoading) {
          return _buildLoadingSkeleton();
        }

        if (event == null) {
          return BuildNoData(
            MediaQuery.of(context).size,
            "No event details available",
            Icons.error_outline,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.eventName != null && event.eventName!.isNotEmpty)
              _buildDetailRow(
                'Event Name',
                event.eventName!,
                valueColor: Colors.black87,
              ),
            if (event.eventType != null && event.eventType!.isNotEmpty)
              _buildDetailRow(
                'Event Type',
                event.eventType!,
                valueColor: Colors.black87,
              ),
            if (event.startDate != null && event.startDate!.isNotEmpty)
              _buildDetailRow(
                'Start Date',
                parseDate(event.startDate!),
                valueColor: Colors.black87,
              ),
            if (event.endDate != null && event.endDate!.isNotEmpty)
              _buildDetailRow(
                'End Date',
                parseDate(event.endDate!),
                valueColor: Colors.black87,
              ),
            if (event.startTime != null &&
                event.startTime!.isNotEmpty &&
                event.startTime != '00:00:00' &&
                event.endTime != null &&
                event.endTime!.isNotEmpty &&
                event.endTime != '00:00:00')
              _buildDetailRow(
                'Time',
                formatTimeRange(event.startTime!, event.endTime!),
                valueColor: Colors.black87,
              ),
            if (event.location != null && event.location!.isNotEmpty)
              _buildDetailRow(
                'Location',
                event.location!,
                valueColor: Colors.black87,
              ),
            if (event.organizerName != null && event.organizerName!.isNotEmpty)
              _buildDetailRow(
                'Organizer',
                event.organizerName!,
                valueColor: Colors.black87,
              ),
            if (event.organizerEmail != null &&
                event.organizerEmail!.isNotEmpty)


            if (event.organizerMobile != null &&
                event.organizerMobile!.isNotEmpty)
              _buildDetailRow(
                'Organizer Mobile',
                event.organizerMobile!,
                valueColor: Colors.black87,
              ),
            if (event.eventContactName != null &&
                event.eventContactName!.isNotEmpty)
              _buildDetailRow(
                'Contact Name',
                event.eventContactName!,
                valueColor: Colors.black87,
              ),

            if (event.eventContactMobile != null &&
                event.eventContactMobile!.isNotEmpty)
              _buildDetailRow(
                'Contact Mobile',
                event.eventContactMobile!,
                valueColor: Colors.black87,
              ),
            if (event.status != null && event.status!.isNotEmpty)
              _buildDetailRow(
                'Status',
                event.status!,
                valueColor: Colors.black87,
              ),
            if (event.summary != null && event.summary!.isNotEmpty)
              _buildDetailRow(
                'Summary',
                event.summary!,
                valueColor: Colors.black87,
              ),
            if (event.eventContactEmail != null &&
                event.eventContactEmail!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3,),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Text(
                      "${event.eventContactEmail}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            if (event.organizerEmail != null && event.organizerEmail!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Organizer Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3,),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Text(
                    "${event.organizerEmail}",
                    style: const TextStyle(
                      color: Colors.black,

                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            if (event.description != null && event.description!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Text(
                      "${event.description}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,

                      ),
                    ),
                  ),
                ],
              )
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'poppins',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
