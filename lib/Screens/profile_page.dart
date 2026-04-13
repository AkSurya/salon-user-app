import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  String _getInitial(User? user) {
    if (user == null) return "U";

    if (user.email != null && user.email!.isNotEmpty) {
      return user.email![0].toUpperCase();
    }

    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
      return user.phoneNumber![1];
    }

    return "U";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 52,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.pink,
                child: Text(
                  _getInitial(user),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Phone Number"),
              subtitle: Text(user?.phoneNumber ?? "Not available"),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              subtitle: Text(user?.email ?? "Not available"),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text("User ID"),
              subtitle: Text(user?.uid ?? "Not available"),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
