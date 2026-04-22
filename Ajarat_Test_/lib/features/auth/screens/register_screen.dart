import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobController = TextEditingController();

  // State Variables
  File? _personalPhoto;
  File? _idPhoto;
  String _selectedRole = 'user'; // 'user' = Tenant, 'owner' = Owner
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // HELPER METHODS
  // ---------------------------------------------------------------------------

  Future<void> _pickImage(bool isPersonal) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isPersonal) {
          _personalPhoto = File(image.path);
        } else {
          _idPhoto = File(image.path);
        }
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        // Backend expects YYYY-MM-DD
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Custom Validation for Images
    if (_personalPhoto == null || _idPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload both Personal and ID photos')),
      );
      return;
    }

    try {
      await Provider.of<AuthProvider>(context, listen: false).register(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        birthDate: _dobController.text,
        personalPhoto: _personalPhoto!,
        idPhoto: _idPhoto!,
        role: _selectedRole,
      );

      if (!mounted) return;

      // Show Success & Go back to Login
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('Your account has been created. Please login.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close Dialog
                Navigator.pop(context); // Go back to Login Screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Registration Failed'),
          content: Text(e.toString().replaceAll('Exception: ', '')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // UI BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. Role Selection
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Tenant'),
                      value: 'user',
                      groupValue: _selectedRole,
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Owner'),
                      value: 'owner', // Must match backend expectation if any
                      groupValue: _selectedRole,
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Personal Info
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Date of Birth (Read Only, opens DatePicker)
              CustomTextField(
                controller: _dobController,
                label: 'Date of Birth',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: _selectDate,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // 3. Password
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
                validator: (v) => v!.length < 8 ? 'Min 8 characters' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                isPassword: true,
                validator: (v) {
                  if (v != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 4. Photos
              const Text('Required Photos', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  // Personal Photo
                  _buildPhotoPicker(
                    label: 'Personal Photo',
                    file: _personalPhoto,
                    onTap: () => _pickImage(true),
                  ),
                  const SizedBox(width: 16),
                  // ID Photo
                  _buildPhotoPicker(
                    label: 'ID Card Photo',
                    file: _idPhoto,
                    onTap: () => _pickImage(false),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 5. Submit Button
              CustomButton(
                text: 'Register',
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper for photo boxes
  Widget _buildPhotoPicker({
    required String label, 
    required File? file, 
    required VoidCallback onTap
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            image: file != null 
                ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
                : null,
          ),
          child: file == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}