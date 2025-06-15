import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/profile/controller/profile_controller.dart';
import 'package:p_square/app/features/profile/views/edit_profile_view.dart';
import 'package:p_square/app/features/profile/views/insurance_view.dart';
import 'package:p_square/app/features/profile/views/widgets/expert_application_dialog.dart';
import 'package:p_square/app/features/profile/views/my_orders_view.dart';
import 'package:p_square/core/constants/string_constants.dart';

import 'my_products_view.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.myProfileLabel),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => EditProfileView());
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Action buttons section
                      _buildActionButtons(),

                      const SizedBox(height: 24),

                      // Logout button
                      _buildLogoutButton(context),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Selling items button
        _buildActionButton(
          icon: Icons.store,
          title: StringConstants.myProdcutLabel,
          subtitle: StringConstants.manageSellingItems,
          onTap: () async {
            await controller.getMyProducts();
            Get.to(() => MyProductsView());
          },
        ),
        const SizedBox(height: 16),

        // Ordered items button
        _buildActionButton(
          icon: Icons.shopping_bag,
          title: StringConstants.myOrders,
          subtitle: StringConstants.manageOrderingItems,
          onTap: () => Get.to(() => MyOrdersView()),
        ),

        const SizedBox(height: 16),
        // Apply for ebing expert
        _buildActionButton(
          icon: Icons.assignment_turned_in_rounded,
          title: StringConstants.applyForExpertLabel,
          subtitle: StringConstants.applyForExpert,
          onTap: () async {
            bool hasApplied = await controller.hasAppliedForExpert();

            if (!hasApplied) {
              final response = await showExpertApplicationSuccessDialog();
              if (response == true) {
                await controller.markAsApplied();
              }
            } else {
              showAlreadyAppliedDialog();
            }
          },
        ),
        const SizedBox(height: 16),

        // Insurance Claim button
        _buildActionButton(
          icon: Icons.assignment,
          title: StringConstants.insuranceLabel,
          subtitle: StringConstants.insurance,
          onTap: () => Get.to(() => InsuranceView()),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.green),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showLogoutDialog(context),
      icon: const Icon(Icons.logout),
      label: const Text(StringConstants.logout),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(StringConstants.logout),
        content: const Text(StringConstants.areYouSureLogOut),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(StringConstants.cancelChanges),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text(
              StringConstants.logout,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
