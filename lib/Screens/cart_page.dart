import 'package:flutter/material.dart';
import 'payment_page.dart';

class CartPage extends StatefulWidget {
  static List<Map<String, dynamic>> cartItems = [];

  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  int get total {
    int sum = 0;
    for (var item in CartPage.cartItems) {
      final int price = (item["price"] ?? 0) as int;
      final int qty = (item["qty"] ?? 1) as int;
      sum += price * qty;
    }
    return sum;
  }

  void increaseQty(int index) {
    setState(() {
      CartPage.cartItems[index]["qty"] =
          (CartPage.cartItems[index]["qty"] ?? 1) + 1;
    });
  }

  void decreaseQty(int index) {
    setState(() {
      int currentQty = CartPage.cartItems[index]["qty"] ?? 1;

      if (currentQty > 1) {
        CartPage.cartItems[index]["qty"] = currentQty - 1;
      } else {
        CartPage.cartItems.removeAt(index);
      }
    });
  }

  void checkout() {
    if (CartPage.cartItems.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          totalAmount: total,
          bookings: CartPage.cartItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: CartPage.cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: CartPage.cartItems.length,
              itemBuilder: (_, i) {
                final item = CartPage.cartItems[i];

                final String title = item["title"] ?? "Service";
                final int price = item["price"] ?? 0;
                final int qty = item["qty"] ?? 1;
                final String date = item["date"] ?? "Not selected";
                final String time = item["time"] ?? "Not selected";
                final String salon = item["salon"] ?? "";

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (salon.isNotEmpty)
                          Text("Salon: $salon"),

                        Text("Date: $date"),
                        Text("Time: $time"),

                        const SizedBox(height: 6),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹$price x $qty",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () =>
                                      decreaseQty(i),
                                ),
                                Text(qty.toString()),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () =>
                                      increaseQty(i),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// TOTAL + CHECKOUT
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₹$total",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: checkout,
                    child: const Text("Proceed to Payment"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
