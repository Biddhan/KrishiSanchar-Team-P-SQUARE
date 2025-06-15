import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/profile/controller/profile_controller.dart';
import 'package:p_square/core/constants/string_constants.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringConstants.myProfileLabel)),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Change picture
              // Center(child: _editProfileSection()),
              // SizedBox(height: 16),
              // Text editing controllers
              _profileEditSection(),
              // Update button
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                  ),
                  onPressed: () {
                    controller.submit();
                  },
                  child: Text(
                    StringConstants.saveChanges,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form _profileEditSection() {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _formFieldWithLabel(
              StringConstants.firstName,
              controller.firstName,
              Icons.person,
              (newValue) {
                if (newValue == null || newValue.isEmpty) {
                  return StringConstants.firstNameRequired;
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            _formFieldWithLabel(
              StringConstants.middleName,
              controller.middleName,
              Icons.person,
              null,
            ),
            SizedBox(height: 8),
            _formFieldWithLabel(
              StringConstants.lastName,
              controller.lastName,
              Icons.person,
              (newValue) {
                if (newValue == null || newValue.isEmpty) {
                  return StringConstants.lastNameRequired;
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            _formFieldWithLabel(
              StringConstants.email,
              controller.email,
              Icons.email,
              (newValue) {
                if (newValue == null || newValue.isEmpty) {
                  return StringConstants.emailRequired;
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            _formFieldWithLabel(
              StringConstants.phoneNumber,
              controller.phoneNumber,
              Icons.phone,
              (newValue) {
                if (newValue == null || newValue.isEmpty) {
                  return StringConstants.phoneNumberRequired;
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            _formFieldWithLabel(
              StringConstants.address,
              controller.address,
              Icons.location_city,
              (newValue) {
                if (newValue == null || newValue.isEmpty) {
                  return StringConstants.addressRequired;
                }
                return null;
              },
            ),

            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _formFieldWithLabel(
    String label,
    TextEditingController textEditingController,
    IconData icon,
    String? Function(String?)? validator, {
    Widget? suffix,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),

        // Text form field
        TextFormField(
          controller: textEditingController,
          obscureText: obscureText,
          decoration: InputDecoration(
            suffixIcon: suffix,
            prefixIcon: Icon(icon, color: Colors.green),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _editProfileSection() {
    return Column(
      children: [
        // Profile image
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          backgroundImage: controller.profileImageUrl.value.isNotEmpty
              ? NetworkImage(controller.profileImageUrl.value)
              : null,
          child: controller.profileImageUrl.value.isEmpty
              ? const Icon(Icons.person, size: 60, color: Colors.grey)
              : null,
        ),
        SizedBox(height: 8),
        // Change picture text
        Text(StringConstants.changeProfile, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
