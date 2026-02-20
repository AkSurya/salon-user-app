import 'package:flutter/material.dart';
import 'cart_page.dart';

class ServiceDetailPage extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {

  DateTime? selectedDate;
  String? selectedTime;

  List<String> timeSlots = [
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "2:00 PM",
    "4:00 PM",
  ];

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
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

    return Scaffold(
      appBar: AppBar(title: Text(widget.service["title"])),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.service["image"],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.service["title"],
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Price: ₹${widget.service["price"]}",
              style: const TextStyle(
                  fontSize: 20, color: Colors.green),
            ),

            const SizedBox(height: 20),

            /// DATE SECTION
            Row(
              children: [
                const Text(
                  "Select Date",
                  style: TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.calendar_month,
                      color: Colors.pink),
                  onPressed: () => pickDate(context),
                ),
              ],
            ),

            if (selectedDate != null)
              Text(
                "Selected: ${selectedDate!.toString().split(" ")[0]}",
              ),

            const SizedBox(height: 10),

            /// TIME SLOTS
            if (selectedDate != null)
              Wrap(
                spacing: 8,
                children: timeSlots.map((time) {
                  return ChoiceChip(
                    label: Text(time),
                    selected: selectedTime == time,
                    selectedColor: Colors.pink,
                    onSelected: (_) {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                  );
                }).toList(),
              ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  if (selectedDate == null ||
                      selectedTime == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Select date & time")),
                    );
                    return;
                  }

                  CartPage.cartItems.add({
                    "title": widget.service["title"],
                    "price": widget.service["price"],
                    "qty": 1,
                    "date": selectedDate
                        .toString()
                        .split(" ")[0],
                    "time": selectedTime,
                  });

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                        content: Text("Added to cart")),
                  );
                },
                child: const Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
