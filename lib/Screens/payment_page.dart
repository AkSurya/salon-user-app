import 'package:flutter/material.dart';
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

  void completePayment(BuildContext context) {
    if (bookings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No bookings available"),
        ),
      );
      return;
    }

    // Copy cart items safely BEFORE clearing
    final List<Map<String, dynamic>> safeBookings =
    List<Map<String, dynamic>>.from(bookings);

    // Combine services (REMOVE "Cart Booking" title)
    final Map<String, dynamic> combinedBooking = {
      "services": safeBookings,
    };

    // Clear cart AFTER copying
    CartPage.cartItems.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingLoadingPage(
          booking: combinedBooking,
          totalAmount: totalAmount,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Booking List
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
                        "${item["date"] ?? ""} | ${item["time"] ?? ""}\nSalon: ${item["salon"] ?? "N/A"}",
                      ),
                      trailing: Text("₹${item["price"] ?? 0}"),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            /// Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "₹$totalAmount",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Pay Button
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
