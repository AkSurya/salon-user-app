import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  State<SalonDetailPage> createState() => _SalonDetailPageState();
}

class _SalonDetailPageState extends State<SalonDetailPage> {
  DateTime? selectedDate;
  String? selectedTime;

  final List<String> timeSlots = [
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
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedTime = null;
      });
    }
  }

  Future<void> _createBooking({
    required String serviceName,
    required int price,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please log in first")),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': userId,
        'salonId': widget.salon["id"] ?? "",
        'salonName': widget.salon["name"] ?? "Salon",
        'serviceName': serviceName,
        'price': price,
        'date': selectedDate!.toIso8601String(),
        'time': selectedTime,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking for $serviceName created")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating booking: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String salonName = widget.salon["name"] ?? "Salon";
    final double rating = (widget.salon["rating"] ?? 0.0).toDouble();
    final String address = widget.salon["address"] ?? "";
    final String phone = widget.salon["phone"] ?? "";
    final String salonType = widget.salon["salonType"] ?? "";

    final List<dynamic> salonServices =
    List<dynamic>.from(widget.salon["services"] ?? []);

    final String localImage =
        widget.salon["localImage"] ?? "assets/images/salons/salon_1.png";

    return Scaffold(
      appBar: AppBar(title: Text(salonName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                localImage,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text("⭐ $rating", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            if (address.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(address,
                        style: const TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            const SizedBox(height: 4),
            if (phone.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.grey, size: 16),
                  const SizedBox(width: 4),
                  Text(phone, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            const SizedBox(height: 4),
            if (salonType.isNotEmpty)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  salonType,
                  style: const TextStyle(color: Colors.pink, fontSize: 13),
                ),
              ),
            const SizedBox(height: 20),

            // DATE SECTION
            Row(
              children: [
                const Text("Select Date",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.calendar_month, color: Colors.pink),
                  onPressed: () => pickDate(context),
                ),
              ],
            ),
            if (selectedDate != null)
              Text("Selected: ${selectedDate!.toString().split(" ")[0]}"),
            const SizedBox(height: 10),
            if (selectedDate != null)
              Wrap(
                spacing: 8,
                children: timeSlots.map((time) {
                  return ChoiceChip(
                    label: Text(time),
                    selected: selectedTime == time,
                    selectedColor: Colors.pink,
                    onSelected: (_) {
                      setState(() => selectedTime = time);
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),

            const Text("Services",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            salonServices.isEmpty
                ? const Text("No services listed yet",
                style: TextStyle(color: Colors.grey))
                : Column(
              children: salonServices.map((serviceName) {
                final matchingServices = widget.allServices.where((s) =>
                (s["title"] ?? "")
                    .toString()
                    .toLowerCase() ==
                    serviceName.toString().toLowerCase());

                final bool found = matchingServices.isNotEmpty;
                final service = found ? matchingServices.first : null;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(serviceName.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(found
                        ? "₹${service!["price"]}"
                        : "Price on request"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      onPressed: () {
                        if (selectedDate == null || selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                Text("Select date & time first")),
                          );
                          return;
                        }

                        // Add to cart (existing logic)
                        CartPage.cartItems.add({
                          "salonId": widget.salon["id"] ?? "",
                          "salonName": salonName,
                          "title": serviceName.toString(),
                          "price": found ? service!["price"] : 0,
                          "qty": 1,
                          "date": selectedDate!.toString().split(" ")[0],
                          "time": selectedTime,
                        });

                        // NEW: Create booking in Firestore
                        _createBooking(
                          serviceName: serviceName.toString(),
                          price: found ? service!["price"] : 0,
                        );
                      },
                      child: const Text("Add",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}