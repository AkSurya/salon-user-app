import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final DateTime _currentMonth = DateTime.now();
  int? _selectedDay;

  // Real salons fetched from Firestore
  List<Map<String, dynamic>> _salons = [];
  bool _isLoading = true;

  final List<String> timeSlots = [
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "2:00 PM",
    "4:00 PM",
    "6:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    _fetchSalons();
  }

  Future<void> _fetchSalons() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('salons').get();
      setState(() {
        _salons = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  int get daysInMonth =>
      DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

  int get firstWeekday =>
      DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;

  void _showDayDetails(int day) {
    if (_salons.isEmpty) {
      showModalBottomSheet(
        context: context,
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text("No salons available yet")),
        ),
      );
      return;
    }

    // Track selected time per salon+service combo
    final Map<String, String?> selectedSlots = {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(16),
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
                      const SizedBox(height: 4),
                      const Center(
                        child: Text(
                          "Select a salon and time slot",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: _salons.length,
                          itemBuilder: (context, salonIndex) {
                            final salon = _salons[salonIndex];
                            final salonName =
                                salon['name'] ?? 'Salon';
                            final salonId = salon['id'] ?? '';
                            final List<dynamic> services =
                            List<dynamic>.from(
                                salon['services'] ?? []);

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.only(
                                  bottom: 12),
                              child: ExpansionTile(
                                title: Text(
                                  salonName,
                                  style: const TextStyle(
                                      fontWeight:
                                      FontWeight.w600),
                                ),
                                subtitle: Text(
                                  salon['address'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),
                                children: services.isEmpty
                                    ? [
                                  const Padding(
                                    padding:
                                    EdgeInsets.all(
                                        12),
                                    child: Text(
                                      "No services listed",
                                      style: TextStyle(
                                          color:
                                          Colors.grey),
                                    ),
                                  )
                                ]
                                    : services.map((service) {
                                  final serviceKey =
                                      "$salonId-$service";
                                  selectedSlots
                                      .putIfAbsent(
                                      serviceKey,
                                          () => null);
                                  final selectedSlot =
                                  selectedSlots[
                                  serviceKey];

                                  return Padding(
                                    padding:
                                    const EdgeInsets
                                        .all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        // Service name
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              service
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize:
                                                  16,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                            // Option B: replace with real price from Firestore when available
                                            const Text(
                                              "Price on visit",
                                              style: TextStyle(
                                                  color: Colors
                                                      .pink,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                            height: 10),

                                        // Time slots
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: timeSlots
                                              .map((slot) {
                                            final isSelected =
                                                selectedSlot ==
                                                    slot;
                                            return ChoiceChip(
                                              label: Text(
                                                  slot),
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
                                                      serviceKey] =
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

                                        // Add to cart button
                                        SizedBox(
                                          width: double
                                              .infinity,
                                          child:
                                          ElevatedButton(
                                            style: ElevatedButton
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
                                                service.toString(),
                                                "salonId":
                                                salonId,
                                                "salonName":
                                                salonName,
                                                "salon":
                                                salonName,
                                                "date":
                                                "$day ${_monthName(_currentMonth.month)} ${_currentMonth.year}",
                                                "time":
                                                selectedSlot,
                                                "price":
                                                0, // Option B: add real price when Firestore has it
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
                                                "Add to Cart"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
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
      body: _isLoading
          ? const Center(
          child: CircularProgressIndicator(color: Colors.pink))
          : Padding(
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
            const SizedBox(height: 8),
            Text(
              "${_salons.length} salon${_salons.length == 1 ? '' : 's'} available",
              style: const TextStyle(
                  color: Colors.grey, fontSize: 13),
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
                  style: const TextStyle(
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
                  final isSelected =
                      _selectedDay == day;
                  final isPast = day <
                      DateTime.now().day &&
                      _currentMonth.month ==
                          DateTime.now().month;

                  return GestureDetector(
                    onTap: isPast
                        ? null
                        : () {
                      setState(() =>
                      _selectedDay = day);
                      _showDayDetails(day);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isPast
                            ? Colors.grey[200]
                            : isSelected
                            ? Colors.pink
                            : _salons.isNotEmpty
                            ? Colors.pink
                            .withOpacity(
                            0.15)
                            : Colors.white,
                        borderRadius:
                        BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(
                            color: Colors.pink,
                            width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            color: isPast
                                ? Colors.grey
                                : isSelected
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