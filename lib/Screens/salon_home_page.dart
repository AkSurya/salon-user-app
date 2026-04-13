import 'dart:async';
import 'package:Beautiq/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'salon_detail_page.dart';
import 'service_detail_page.dart';
import 'cart_page.dart';

enum FilterType { all, male, female }

class SalonHomePage extends StatefulWidget {
  const SalonHomePage({super.key});

  @override
  State<SalonHomePage> createState() => _SalonHomePageState();
}

class _SalonHomePageState extends State<SalonHomePage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  FilterType selectedFilter = FilterType.all;

  final List<Map<String, dynamic>> services = const [
    {
      "title": "Haircut",
      "image": "assets/images/services/haircut.png",
      "price": 150,
      "type": "male"
    },
    {
      "title": "Shaving",
      "image": "assets/images/services/shaving.png",
      "price": 50,
      "type": "male"
    },
    {
      "title": "Facial",
      "image": "assets/images/services/facial.png",
      "price": 200,
      "type": "female"
    },
    {
      "title": "MakeUp",
      "image": "assets/images/services/makeup.png",
      "price": 500,
      "type": "female"
    },
    {
      "title": "Threading",
      "image": "assets/images/services/threading.png",
      "price": 150,
      "type": "female"
    },
    {
      "title": "Massage",
      "image": "assets/images/services/massage.png",
      "price": 400,
      "type": "female"
    },
  ];

  final List<Map<String, dynamic>> salons = const [
    {
      "name": "Royal Cuts Salon",
      "image": "assets/images/salons/salon_1.png",
      "rating": 4.5,
      "type": "male",
      "offer": "20% OFF on first visit",
      "services": ["Haircut", "Shaving"]
    },
    {
      "name": "Urban Style Studio",
      "image": "assets/images/salons/salon_2.png",
      "rating": 4.2,
      "type": "female",
      "offer": "Free facial on booking",
      "services": ["Facial", "MakeUp", "Threading"]
    },
    {
      "name": "Fashion Hub",
      "image": "assets/images/salons/salon_4.png",
      "rating": 4.4,
      "type": "female",
      "offer": "₹100 OFF today",
      "services": ["MakeUp", "Massage"]
    },
    {
      "name": "Grooming House",
      "image": "assets/images/salons/salon_3.png",
      "rating": 4.8,
      "type": "male",
      "offer": "Premium grooming",
      "services": ["Haircut", "Shaving"]
    },
  ];


  List<Map<String, dynamic>> get filteredServices {
    if (selectedFilter == FilterType.all) return services;
    return services.where((s) => s["type"] == selectedFilter.name).toList();
  }

  List<Map<String, dynamic>> get filteredSalons {
    if (selectedFilter == FilterType.all) return salons;
    return salons.where((s) => s["type"] == selectedFilter.name).toList();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_scrollController.hasClients) {
        final max = _scrollController.position.maxScrollExtent;
        final next = _scrollController.offset + 200;

        _scrollController.animateTo(
          next >= max ? 0 : next,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
  backgroundColor: Colors.white,
  centerTitle: true,
  title: const Text(
    "Beautiq",
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfilePage(),
            ),
          );
        },
        child: const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.pink,
          child: Icon(Icons.person, color: Colors.white),
        ),
      ),
    ),
  ],
),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text("Hello 👋", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            const Text(
              "Looking for a fresh style today?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// 🔍 SEARCH + FILTER TOGGLE
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search services or salons",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                /// FILTER DROPDOWN
                PopupMenuButton<FilterType>(
                  onSelected: (value) {
                    setState(() {
                      selectedFilter = value;
                    });
                  },
                  color: Colors.white, // dropdown background
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: FilterType.all,
                      child: Text("All", style: TextStyle(color: Colors.black)),
                    ),
                    PopupMenuItem(
                      value: FilterType.male,
                      child: Text("Male", style: TextStyle(color: Colors.black)),
                    ),
                    PopupMenuItem(
                      value: FilterType.female,
                      child:
                      Text("Female", style: TextStyle(color: Colors.black)),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// SALONS
            const Text(
              "Salons Near You",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 160,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: filteredSalons.length,
                itemBuilder: (context, i) {
                  final salon = filteredSalons[i];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SalonDetailPage(
                            salon: salon,
                            allServices: services,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 190,
                      margin: const EdgeInsets.only(right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          /// IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              salon["image"],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          /// OVERLAY
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),

                          /// TEXT
                          Positioned(
                            left: 12,
                            bottom: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  salon["name"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      salon["rating"].toString(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            /// SERVICES
            const Text(
              "Our Services",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredServices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, i) {
                final service = filteredServices[i];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ServiceDetailPage(service: service),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        /// IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            service["image"],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// OVERLAY
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),

                        /// TEXT
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service["title"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₹${service["price"]}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartPage()),
          );
        },
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }
}
