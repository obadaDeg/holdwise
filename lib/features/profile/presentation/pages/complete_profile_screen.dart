import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/app/utils/api_path.dart';
import 'package:holdwise/common/services/firestore_services.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  bool _isLoading = true; // For loading current profile data.

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /// Loads the current profile data and pre-populates the controllers.
  Future<void> _loadProfileData() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      // Pre-populate with what’s available from the Firebase user.
      _nameController.text = user.displayName ?? "";
      _phoneNumberController.text = user.phoneNumber ?? "";
      try {
        final Map<String, dynamic> userData =
            await FirestoreServices.instance.getDocument(
          path: ApiPath.user(user.uid),
          builder: (data, documentId) => data,
        );
        _aboutController.text = userData['about'] ?? "";
      } catch (e) {
        debugPrint('Error loading profile data: $e');
      }
    }
    setState(() {
      _isLoading = false;
    });
    if (_isProfileComplete()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      });
    }
  }

  /// Checks if all required profile fields are provided.
  bool _isProfileComplete() {
    return _nameController.text.trim().isNotEmpty &&
        _phoneNumberController.text.trim().isNotEmpty &&
        _aboutController.text.trim().isNotEmpty;
  }

  /// Called when the user submits the form.
  bool _submitProfile() {
    if (_formKey.currentState!.validate()) {
      try {
        // context.read<AuthCubit>().updateProfile(
        //       _nameController.text.trim(),
        //       _phoneNumberController.text.trim(),
        //       _aboutController.text.trim(),
        //     );
        // If it works, the AuthCubit will emit AuthSuccess -> see the BlocConsumer listener
        return true;
      } catch (e) {
        // Handle or log the error
        return false;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoleBasedAppBar(title: 'Complete Your Profile', displayActions: false),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                } else if (state is AuthError) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                final isUpdating = state is AuthLoading;

                // Build a list of form fields only for the missing parts.
                final List<Widget> missingFields = [];

                if (_nameController.text.trim().isEmpty) {
                  missingFields.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  );
                }

                if (_phoneNumberController.text.trim().isEmpty) {
                  missingFields.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  );
                }

                if (_aboutController.text.trim().isEmpty) {
                  missingFields.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLength: 200,
                        controller: _aboutController,
                        decoration: const InputDecoration(
                          labelText: "About",
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(color: AppColors.primary600),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please provide some details about yourself';
                          }
                          return null;
                        },
                      ),
                    ),
                  );
                }

                // If no fields are missing, inform the user.
                if (missingFields.isEmpty) {
                  missingFields.add(
                    const Text(
                      "Your profile is already complete!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                  missingFields.add(const SizedBox(height: 20));
                  missingFields.add(
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.pushReplacementNamed(
                        //     context, AppRoutes.dashboard);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Go to Dashboard"),
                    ),
                  );
                } else {
                  // Prepend an instruction message.
                  missingFields.insert(
                    0,
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Please complete the missing parts of your profile:",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }

                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...missingFields,
                          isUpdating
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _submitProfile,
                                  child: const Text("Update Profile"),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
