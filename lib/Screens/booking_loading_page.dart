import 'dart:async';
import 'package:flutter/material.dart';
import 'booking_confirmation_page.dart';

class BookingLoadingPage extends StatefulWidget {
  final Map<String, dynamic> booking;
  final int totalAmount;

  const BookingLoadingPage({
    super.key,
    required this.booking,
    required this.totalAmount,
  });

  @override
  State<BookingLoadingPage> createState() =>
      _BookingLoadingPageState();
}

class _BookingLoadingPageState extends State<BookingLoadingPage>
    with TickerProviderStateMixin {

  late AnimationController _rotationController;
  late AnimationController _pulseController;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();

    _rotationController =
    AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseController =
    AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isCompleted = true;
      });

      _rotationController.stop();
      _pulseController.stop();

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingConfirmationPage(
              booking: widget.booking,
              totalAmount: widget.totalAmount,
            ),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, animation) =>
              FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              ),
          child: isCompleted
              ? _buildSuccess()
              : _buildAnimatedLoader(theme),
        ),
      ),
    );
  }

  Widget _buildAnimatedLoader(ThemeData theme) {
    return Column(
      key: const ValueKey("loading"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + (_pulseController.value * 0.2),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                child: child,
              ),
            );
          },
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 6.3,
                child: child,
              );
            },
            child: Icon(
              Icons.content_cut, // salon scissors
              size: 50,
              color: theme.colorScheme.primary,
            ),
          ),
        ),

        const SizedBox(height: 30),

        Text(
          "Confirming your booking...",
          style: theme.textTheme.titleMedium,
        ),

        const SizedBox(height: 10),

        Text(
          "Preparing your appointment",
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      key: const ValueKey("success"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 60,
            ),
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          "Booking Confirmed!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
