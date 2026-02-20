import 'package:flutter/material.dart';
import 'booking_loading_page.dart';

class EmergencyBookingPage extends StatefulWidget {
  const EmergencyBookingPage({super.key});

  @override
  State<EmergencyBookingPage> createState() =>
      _EmergencyBookingPageState();
}

class _EmergencyBookingPageState
    extends State<EmergencyBookingPage> {

  final Map<String, int> servicePrices = {
    "Haircut": 400,
    "Shaving": 250,
    "Beard Trim": 300,
    "Facial": 900,
    "Cleanup": 600,
  };

  final List<Map<String, dynamic>> emergencySalons = [
    {
      "name": "Quick Cuts Salon",
      "time": "10 mins",
      "services": ["Haircut", "Shaving"],
    },
    {
      "name": "Express Style Studio",
      "time": "15 mins",
      "services": ["Haircut", "Beard Trim"],
    },
    {
      "name": "Rapid Glow Salon",
      "time": "20 mins",
      "services": ["Facial", "Cleanup"],
    },
  ];

  final Map<String, String?> selectedService = {};

  void _bookEmergency(
      String salonName,
      String service,
      String time,
      int price,
      ) {

    Map<String, dynamic> bookingData = {
      "title": service,
      "salon": salonName,
      "date": DateTime.now().toString(),
      "time": "Ready in $time",
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingLoadingPage(
          booking: bookingData,
          totalAmount: price,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("Emergency Booking"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "These salons provide instant service for urgent bookings.",
                      style: TextStyle(
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: emergencySalons.length,
                itemBuilder: (context, index) {

                  final salon = emergencySalons[index];
                  final salonName = salon["name"];
                  final readyTime = salon["time"];
                  final services =
                  (salon["services"] as List)
                      .cast<String>();

                  selectedService.putIfAbsent(
                      salonName, () => null);

                  final selected =
                  selectedService[salonName];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                    margin:
                    const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding:
                      const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                salonName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                    horizontal: 10,
                                    vertical: 4),
                                decoration:
                                BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius:
                                  BorderRadius
                                      .circular(20),
                                ),
                                child: const Text(
                                  "EMERGENCY",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(Icons.timer,
                                  size: 18),
                              const SizedBox(width: 6),
                              Text(
                                "Ready in $readyTime",
                                style:
                                const TextStyle(
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 8,
                            children: services
                                .map((service) {

                              final isSelected =
                                  selected == service;

                              return ChoiceChip(
                                label: Text(
                                    "$service (₹${servicePrices[service]})"),
                                selected: isSelected,
                                selectedColor:
                                Colors.redAccent,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                onSelected: (value) {
                                  setState(() {
                                    selectedService[
                                    salonName] =
                                    value
                                        ? service
                                        : null;
                                  });
                                },
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                Colors.redAccent,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(12),
                                ),
                              ),
                              onPressed:
                              selected == null
                                  ? null
                                  : () {
                                _bookEmergency(
                                  salonName,
                                  selected,
                                  readyTime,
                                  servicePrices[
                                  selected]!,
                                );
                              },
                              child: const Text(
                                  "Book Instantly"),
                            ),
                          ),
                        ],
                      ),
                    ),
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
