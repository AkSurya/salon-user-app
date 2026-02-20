import 'dart:math';
import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

class BookingConfirmationPage extends StatelessWidget {
  final Map<String, dynamic> booking;
  final int totalAmount;

  const BookingConfirmationPage({
    super.key,
    required this.booking,
    required this.totalAmount,
  });

  String generateBookingId() {
    final random = Random();
    return "BQ${100000 + random.nextInt(900000)}";
  }

  List<Map<String, dynamic>> _extractServices() {
    final services = booking["services"];

    // CART BOOKING
    if (services is List && services.isNotEmpty) {
      return services
          .map<Map<String, dynamic>>(
              (e) => Map<String, dynamic>.from(e))
          .toList();
    }

    // SINGLE BOOKING (Emergency / Normal)
    if (booking["title"] != null) {
      return [
        {
          "title": booking["title"],
          "date": booking["date"],
          "time": booking["time"],
          "salon": booking["salon"],
        }
      ];
    }

    return [];
  }


  void addToCalendar() {
    final extractedServices = _extractServices();

    if (extractedServices.isEmpty) return;

    final firstService = extractedServices.first;

    DateTime selectedDate;
    try {
      selectedDate =
          DateTime.parse(firstService["date"] ?? "");
    } catch (e) {
      selectedDate = DateTime.now();
    }

    final event = Event(
      title: firstService["title"] ?? "Salon Service",
      description:
      "Salon Booking at ${firstService["salon"] ?? "Salon"}",
      location: firstService["salon"] ?? "Salon",
      startDate: selectedDate,
      endDate: selectedDate.add(
        const Duration(hours: 1),
      ),
    );

    Add2Calendar.addEvent2Cal(event);
  }

  @override
  Widget build(BuildContext context) {
    final bookingId = generateBookingId();
    final extractedServices = _extractServices();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Booking Confirmed"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 90,
            ),

            const SizedBox(height: 20),

            const Text(
              "Payment Successful!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding:
                const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    _infoRow(
                        "Booking ID", bookingId),

                    const SizedBox(height: 12),

                    if (extractedServices.isNotEmpty) ...[

                      if (extractedServices.length >
                          1)
                        const Text(
                          "Services:",
                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                      const SizedBox(height: 10),

                      ...extractedServices
                          .map((service) {
                        final title =
                            service["title"] ??
                                "Service";
                        final date =
                        service["date"];
                        final time =
                        service["time"];
                        final salon =
                        service["salon"];

                        return Padding(
                          padding:
                          const EdgeInsets
                              .symmetric(
                              vertical: 6),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [

                              Text(
                                extractedServices
                                    .length >
                                    1
                                    ? "• $title"
                                    : title,
                                style:
                                const TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),

                              if (date != null &&
                                  date
                                      .toString()
                                      .isNotEmpty)
                                Text(
                                    "Date: $date"),

                              if (time != null &&
                                  time
                                      .toString()
                                      .isNotEmpty)
                                Text(
                                    "Time: $time"),

                              if (salon != null &&
                                  salon
                                      .toString()
                                      .isNotEmpty)
                                Text(
                                    "Salon: $salon"),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 12),

                      _infoRow("Amount Paid",
                          "₹$totalAmount"),
                    ] else ...[

                      const Text(
                        "Booking Confirmed",
                        style: TextStyle(
                            color: Colors.grey),
                      ),

                      const SizedBox(height: 8),

                      _infoRow("Amount Paid",
                          "₹$totalAmount"),
                    ],
                  ],
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(
                    Icons.calendar_month),
                label:
                const Text("Add to Calendar"),
                onPressed: addToCalendar,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.popUntil(
                      context,
                          (route) =>
                      route.isFirst);
                },
                child:
                const Text("Back to Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
      String title, String value) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
          vertical: 6),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment
            .spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight:
              FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign:
              TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
