import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_page.dart';
import 'booking_loading_page.dart';

class PaymentPage extends StatelessWidget {
  final int totalAmount;
  final List<Map<String, dynamic>> bookings;

  const PaymentPage({
    super.key,
    required this.totalAmount,
    required this.bookings,
  });

  Future<void> completePayment(BuildContext context) async {
    if (bookings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No bookings available")),
      );
      return;
    }

    // Copy cart items safely BEFORE clearing
    final List<Map<String, dynamic>> safeBookings =
    List<Map<String, dynamic>>.from(bookings);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please log in first")),
        );
        return;
      }

      // Get user name from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final userName = userDoc.data()?['name'] ?? 'Customer';

      // Save each booking to Firestore
      final List<String> bookingIds = [];
      for (final booking in safeBookings) {
        final docRef =
        await FirebaseFirestore.instance.collection('bookings').add({
          'userId': user.uid,
          'customer': userName,
          'salonId': booking['salonId'] ?? '',
          'salonName': booking['salonName'] ?? booking['salon'] ?? '',
          'serviceName': booking['title'] ?? '',
          'service': booking['title'] ?? '',
          'price': booking['price'] ?? 0,
          'date': booking['date'] ?? '',
          'time': booking['time'] ?? '',
          'status': 'confirmed',
          'isVerified': false,
          'color': 'pink',
          'totalAmount': totalAmount,
          'createdAt': FieldValue.serverTimestamp(),
        });
        bookingIds.add(docRef.id);
      }

      // Clear cart AFTER saving
      CartPage.cartItems.clear();

      // Combined booking data for confirmation page
      final Map<String, dynamic> combinedBooking = {
        "services": safeBookings,
        "bookingIds": bookingIds,
        "customerName": userName,
      };

      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingLoadingPage(
            booking: combinedBooking,
            totalAmount: totalAmount,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: bookings.isEmpty
                  ? const Center(
                child: Text(
                  "No bookings added",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (_, i) {
                  final item = bookings[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(item["title"] ?? ""),
                      subtitle: Text(
                        "${item["date"] ?? ""} | ${item["time"] ?? ""}\nSalon: ${item["salonName"] ?? item["salon"] ?? "N/A"}",
                      ),
                      trailing: Text("₹${item["price"] ?? 0}"),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹$totalAmount",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: bookings.isEmpty
                    ? null
                    : () => completePayment(context),
                child: const Text("Pay Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}