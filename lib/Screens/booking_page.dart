import 'package:flutter/material.dart';
import 'cart_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final DateTime _currentMonth = DateTime.now();

  /// Dummy availability data
  final Map<int, List<Map<String, dynamic>>> salonAvailability = {
    3: [
      {
        "name": "Royal Cuts Salon",
        "services": ["Haircut", "Facial"],
      },
      {
        "name": "Urban Style Studio",
        "services": ["Massage"],
      },
    ],
    7: [
      {
        "name": "Fashion Hub",
        "services": ["MakeUp", "Threading"],
      },
    ],
    12: [
      {
        "name": "Modern Style Studio",
        "services": ["Haircut", "Shaving"],
      },
    ],
  };

  /// Service Prices
  final Map<String, int> servicePrices = {
    "Haircut": 300,
    "Facial": 700,
    "Massage": 1000,
    "MakeUp": 1500,
    "Threading": 200,
    "Shaving": 250,
  };

  int get daysInMonth =>
      DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

  int get firstWeekday =>
      DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;

  /// SHOW BOOKING DETAILS
  void _showDayDetails(int day) {
    final salons = salonAvailability[day];

    if (salons == null) {
      showModalBottomSheet(
        context: context,
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text("No salons available")),
        ),
      );
      return;
    }

    /// Stores selected time for each service
    final Map<String, String?> selectedSlots = {};

    final timeSlots = [
      "10:00 AM",
      "11:00 AM",
      "12:00 PM",
      "2:00 PM",
      "4:00 PM",
      "6:00 PM",
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "$day ${_monthName(_currentMonth.month)} ${_currentMonth.year}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ...salons.map((salon) {
                      final services =
                      (salon["services"] as List<dynamic>)
                          .cast<String>();

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            salon["name"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: services.map((service) {
                            selectedSlots.putIfAbsent(
                                service, () => null);

                            final selectedSlot =
                            selectedSlots[service];

                            return Padding(
                              padding:
                              const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  /// Service name + price
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        service,
                                        style:
                                        const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),
                                      Text(
                                        "₹${servicePrices[service] ?? 500}",
                                        style:
                                        const TextStyle(
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                          color:
                                          Colors.pink,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                      height: 10),

                                  /// Time slots
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                    timeSlots.map(
                                            (slot) {
                                          final isSelected =
                                              selectedSlot ==
                                                  slot;

                                          return ChoiceChip(
                                            label:
                                            Text(slot),
                                            selected:
                                            isSelected,
                                            selectedColor:
                                            Colors.pink,
                                            labelStyle:
                                            TextStyle(
                                              color: isSelected
                                                  ? Colors
                                                  .white
                                                  : Colors
                                                  .black,
                                            ),
                                            onSelected:
                                                (selected) {
                                              setModalState(
                                                      () {
                                                    selectedSlots[
                                                    service] =
                                                    selected
                                                        ? slot
                                                        : null;
                                                  });
                                            },
                                          );
                                        }).toList(),
                                  ),

                                  const SizedBox(
                                      height: 14),

                                  /// Confirm button
                                  SizedBox(
                                    width:
                                    double.infinity,
                                    child:
                                    ElevatedButton(
                                      style:
                                      ElevatedButton
                                          .styleFrom(
                                        backgroundColor:
                                        Colors.pink,
                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              24),
                                        ),
                                      ),
                                      onPressed:
                                      selectedSlot ==
                                          null
                                          ? null
                                          : () {
                                        final bookingData =
                                        {
                                          "title":
                                          service,
                                          "salon":
                                          salon["name"],
                                          "date":
                                          "$day ${_monthName(_currentMonth.month)} ${_currentMonth.year}",
                                          "time":
                                          selectedSlot,
                                          "price":
                                          servicePrices[
                                          service] ??
                                              500,
                                        };

                                        CartPage
                                            .cartItems
                                            .add(
                                            bookingData);

                                        Navigator.pop(
                                            context);

                                        Navigator.pushNamed(
                                            context,
                                            '/cart');
                                      },
                                      child: const Text(
                                          "Confirm Booking"),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("Bookings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "${_monthName(_currentMonth.month)} ${_currentMonth.year}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: const [
                "Mon",
                "Tue",
                "Wed",
                "Thu",
                "Fri",
                "Sat",
                "Sun"
              ]
                  .map(
                    (d) => Text(
                  d,
                  style: TextStyle(
                      fontWeight: FontWeight.w600),
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: GridView.builder(
                itemCount:
                daysInMonth + firstWeekday - 1,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemBuilder: (_, index) {
                  if (index < firstWeekday - 1) {
                    return const SizedBox();
                  }

                  final day =
                      index - (firstWeekday - 2);
                  final hasSalon =
                  salonAvailability
                      .containsKey(day);

                  return GestureDetector(
                    onTap: () =>
                        _showDayDetails(day),
                    child: Container(
                      decoration: BoxDecoration(
                        color: hasSalon
                            ? Colors.pink
                            : Colors.white,
                        borderRadius:
                        BorderRadius.circular(
                            10),
                      ),
                      child: Center(
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            color: hasSalon
                                ? Colors.white
                                : Colors.black,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
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

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}
