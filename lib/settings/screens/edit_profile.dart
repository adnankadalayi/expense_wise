import 'package:expense_wise/settings/controllers/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final EditProfileController controller = Get.put(EditProfileController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5C842), Color(0xFFF7B500)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(24, 60, 24, 16),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 800),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(0, 0, 0),
                onEnd: () {
                  // Initial transform to mimic fadeInLeft
                },
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily:
                        '-apple-system, BlinkMacSystemFont, Segoe UI, Roboto',
                  ),
                ),
              ),
            ),
            // Profile Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedContainer(
                width: double.infinity,
                duration: Duration(milliseconds: 800),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(0, 0, 0),
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Obx(() => GestureDetector(
                            onTap: controller.onAvatarTap,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFF7B500),
                                    Color(0xFFF5C842)
                                  ],
                                ),
                              ),
                              transform: Matrix4.identity()
                                ..scale(controller.isAvatarTapped.value
                                    ? 0.95
                                    : 1.0),
                              child: Center(
                                child: Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        '-apple-system, BlinkMacSystemFont, Segoe UI, Roboto',
                                  ),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(height: 16),
                      Text(
                        'Tap to change profile picture',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontFamily:
                              '-apple-system, BlinkMacSystemFont, Segoe UI, Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 800),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(0, 0, 0),
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form Group: Full Name
                        _buildFormGroup(
                          label: 'FULL NAME',
                          child: Obx(() => TextFormField(
                                initialValue: controller.fullName.value,
                                decoration:
                                    _inputDecoration('Enter your full name'),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                  fontFamily:
                                      '-apple-system, BlinkMacSystemFont, Segoe UI, Roboto',
                                ),
                                onChanged: controller.updateFullName,
                              )),
                        ),
                        SizedBox(height: 20),
                        // Form Group: Email
                        _buildFormGroup(
                          label: 'EMAIL ADDRESS',
                          child: Obx(() => TextFormField(
                                initialValue: controller.email.value,
                                decoration:
                                    _inputDecoration('Enter your email'),
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                  fontFamily:
                                      '-apple-system, BlinkMacSystemFont, Segoe UI, Roboto',
                                ),
                                onChanged: controller.updateEmail,
                              )),
                        ),
                        SizedBox(height: 20),
                        // Form Group: Phone Number
                        _buildFormGroup(
                          label: 'PHONE NUMBER',
                          child: Obx(() => TextFormField(
                                initialValue: controller.phoneNumber.value,
                                decoration:
                                    _inputDecoration('Enter your phone number'),
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                  fontFamily:
                                      '-apple-system, BlinkMacSystemFont, Segoe UI, Roboto',
                                ),
                                onChanged: controller.updatePhoneNumber,
                              )),
                        ),
                        SizedBox(height: 20),
                        // Form Group: Nationality
                        _buildFormGroup(
                          label: 'NATIONALITY',
                          child: Obx(() => DropdownButtonFormField<String>(
                                value: controller.nationality.value,
                                decoration:
                                    _inputDecoration('Select your nationality'),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                  fontFamily:
                                      '-apple-system, BlinkMacSystemFont, Segoe UI, Roboto',
                                ),
                                items: [
                                  'United States',
                                  'Canada',
                                  'United Kingdom',
                                  'Australia',
                                  'India',
                                  'France',
                                  'Germany'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: controller.updateNationality,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFF666666),
                                ),
                              )),
                        ),
                        SizedBox(height: 24),
                        // Button Group
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => GestureDetector(
                                    onTap: controller.onCancelTap,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 150),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFFF7B500).withOpacity(0.1),
                                        border: Border.all(
                                            color: Color(0xFFF7B500)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      transform: Matrix4.identity()
                                        ..scale(controller.isCancelTapped.value
                                            ? 0.98
                                            : 1.0),
                                      child: Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFF7B500),
                                            fontFamily:
                                                '-apple-system, BlinkMacSystemFont, Segoe UI, Roboto',
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Obx(() => GestureDetector(
                                    onTap: controller.onSaveTap,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 150),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF7B500),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      transform: Matrix4.identity()
                                        ..scale(controller.isSaveTapped.value
                                            ? 0.98
                                            : 1.0),
                                      child: Center(
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontFamily:
                                                '-apple-system, BlinkMacSystemFont, Segoe UI, Roboto',
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormGroup({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
            letterSpacing: 1,
            fontFamily: '-apple-system, BlinkMacSystemFont, Segoe UI, Roboto',
          ),
        ),
        SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Color(0xFF999999),
        fontFamily: '-apple-system, BlinkMacSystemFont, Segoe UI, Roboto',
      ),
      filled: true,
      fillColor: Color(0xFFF8F9FA),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFE5E5E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFF7B500)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFE5E5E5)),
      ),
    );
  }
}
