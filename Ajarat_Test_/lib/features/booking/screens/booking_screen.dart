
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../home/models/apartment_model.dart';
import '../providers/booking_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_textfield.dart';

class BookingScreen extends StatefulWidget {
  final Apartment apartment;

  const BookingScreen({super.key, required this.apartment});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart 
          ? DateTime.now() 
          : (_startDate?.add(const Duration(days: 1)) ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
          // Reset end date if it becomes invalid
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
            _endDateController.clear();
          }
        } else {
          _endDate = picked;
          _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates')),
      );
      return;
    }

    try {
      await Provider.of<BookingProvider>(context, listen: false).createBooking(
        apartmentId: widget.apartment.id,
        startDate: _startDate!,
        endDate: _endDate!,
      );

      if (!mounted) return;

      // Success Message & Pop to Home
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Booking Successful!'),
          content: const Text('Your booking request has been sent.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close Dialog
                Navigator.of(context).popUntil((route) => route.isFirst); // Go to Home
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<BookingProvider>(context).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Apartment')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking for: ${widget.apartment.city}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // Start Date
            CustomTextField(
              controller: _startDateController,
              label: 'Check-in Date',
              icon: Icons.calendar_today,
              readOnly: true,
              onTap: () => _pickDate(true),
            ),
            const SizedBox(height: 16),

            // End Date
            CustomTextField(
              controller: _endDateController,
              label: 'Check-out Date',
              icon: Icons.calendar_today,
              readOnly: true,
              onTap: () => _pickDate(false),
            ),
            const SizedBox(height: 32),

            // Confirm Button
            CustomButton(
              text: 'Confirm Booking',
              isLoading: isLoading,
              onPressed: _submitBooking,
            ),
          ],
        ),
      ),
    );
  }
}