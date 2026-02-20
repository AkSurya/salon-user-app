import 'package:flutter/material.dart';
import 'cart_page.dart';

class SalonDetailPage extends StatefulWidget {
  final Map<String, dynamic> salon;
  final List<Map<String, dynamic>> allServices;

  const SalonDetailPage({
    super.key,
    required this.salon,
    required this.allServices,
  });

  @override
  State<SalonDetailPage> createState() =>
      _SalonDetailPageState();
}

class _SalonDetailPageState extends State<SalonDetailPage> {

  DateTime? selectedDate;
  String? selectedTime;

  List<String> timeSlots = [
    "10:00 AM",
    "11:00 AM",
    "1:00 PM",
    "3:00 PM",
    "5:00 PM",
  ];

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now()
          .add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final List salonServices =
    widget.salon["services"];

    return Scaffold(
      appBar:
      AppBar(title: Text(widget.salon["name"])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius:
              BorderRadius.circular(16),
              child: Image.asset(
                widget.salon["image"],
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "⭐ ${widget.salon["rating"]}",
              style:
              const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 6),

            Text(
              widget.salon["offer"],
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green),
            ),

            const SizedBox(height: 20),

            /// DATE SECTION
            Row(
              children: [
                const Text(
                  "Select Date",
                  style: TextStyle(
                      fontWeight:
                      FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                      Icons.calendar_month,
                      color: Colors.pink),
                  onPressed: () =>
                      pickDate(context),
                ),
              ],
            ),

            if (selectedDate != null)
              Text(
                  "Selected: ${selectedDate!.toString().split(" ")[0]}"),

            const SizedBox(height: 10),

            if (selectedDate != null)
              Wrap(
                spacing: 8,
                children: timeSlots.map((time) {
                  return ChoiceChip(
                    label: Text(time),
                    selected:
                    selectedTime == time,
                    selectedColor:
                    Colors.pink,
                    onSelected: (_) {
                      setState(() {
                        selectedTime =
                            time;
                      });
                    },
                  );
                }).toList(),
              ),

            const SizedBox(height: 20),

            const Text(
              "Services",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...salonServices.map((serviceName) {
              final service =
              widget.allServices.firstWhere(
                    (s) =>
                s["title"] ==
                    serviceName,
              );

              return Card(
                margin: const EdgeInsets.only(
                    bottom: 12),
                child: ListTile(
                  title: Text(
                    service["title"],
                    style: const TextStyle(
                        fontWeight:
                        FontWeight.w600),
                  ),
                  subtitle:
                  Text("₹${service["price"]}"),
                  trailing: ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.pink,
                    ),
                    onPressed: () {

                      if (selectedDate ==
                          null ||
                          selectedTime ==
                              null) {
                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Select date & time first")),
                        );
                        return;
                      }

                      CartPage.cartItems.add({
                        "title":
                        service["title"],
                        "price":
                        service["price"],
                        "qty": 1,
                        "date": selectedDate!
                            .toString()
                            .split(" ")[0],
                        "time":
                        selectedTime,
                      });

                      ScaffoldMessenger.of(
                          context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                              "${service["title"]} added to cart"),
                        ),
                      );
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(
                          color:
                          Colors.white),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
