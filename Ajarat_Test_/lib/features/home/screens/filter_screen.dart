import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/apartment_provider.dart';
import '../../../shared/widgets/custom_button.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Hardcoded list of cities for now (Ideally fetch from backend)
  final List<String> _cities = ['Cairo', 'Giza', 'Alexandria', 'Luxor', 'Aswan'];
  String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter Apartments')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select City', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            Wrap(
              spacing: 10,
              children: _cities.map((city) {
                final isSelected = _selectedCity == city;
                return ChoiceChip(
                  label: Text(city),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCity = selected ? city : null;
                    });
                  },
                );
              }).toList(),
            ),
            
            const Spacer(),
            
            // Apply Button
            CustomButton(
              text: 'Apply Filters',
              onPressed: () {
                // Call the Provider to filter the list
                Provider.of<ApartmentProvider>(context, listen: false).filterByCity(_selectedCity);
                Navigator.pop(context); // Close screen
              },
            ),
          ],
        ),
      ),
    );
  }
}