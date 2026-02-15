import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Beautiq/screens/main_navigation.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _boyMove;
  late Animation<double> _girlMove;
  late Animation<double> _boyFade;
  late Animation<double> _girlFade;
  late Animation<double> _salonFloat;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(); // 🔥 Repeating animation

    _boyMove = Tween<double>(begin: -80, end: 150).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );

    _girlMove = Tween<double>(begin: -80, end: 150).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeInOut),
      ),
    );

    _boyFade = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.45),
      ),
    );

    _girlFade = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.85, 0.95),
      ),
    );

    _salonFloat = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _textFade = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigation(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _salonIcon() {
    return AnimatedBuilder(
      animation: _salonFloat,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, _salonFloat.value),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade50,
                  Colors.pink.shade100,
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.25),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: const [
                Icon(Icons.storefront,
                    size: 85, color: Colors.pink),
                Positioned(
                  bottom: 20,
                  child: Icon(Icons.content_cut,
                      size: 32, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _boy() {
    return FadeTransition(
      opacity: _boyFade,
      child: const Icon(
        Icons.directions_walk,
        size: 55,
        color: Colors.black87,
      ),
    );
  }

  Widget _girl() {
    return FadeTransition(
      opacity: _girlFade,
      child: Transform.translate(
        offset: const Offset(0, 2),
        child: const Icon(
          Icons.pregnant_woman,
          size: 52,
          color: Colors.pink,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(
              height: 200,
              width: 340,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [

                      Positioned(
                        right: 25,
                        child: _salonIcon(),
                      ),

                      Positioned(
                        left: _boyMove.value,
                        child: _boy(),
                      ),

                      Positioned(
                        left: _girlMove.value,
                        child: _girl(),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            FadeTransition(
              opacity: _textFade,
              child: const Text(
                "Welcome to Beautiq",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 10),

            FadeTransition(
              opacity: _textFade,
              child: Text(
                "Book • Relax • Glow",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
