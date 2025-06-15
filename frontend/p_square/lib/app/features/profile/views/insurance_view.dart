import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/profile/controller/profile_controller.dart';
import 'package:p_square/app/features/profile/models/insurance_company_model.dart';
import 'package:p_square/app/features/profile/models/insurance_plan_model.dart';

class InsuranceView extends GetView<ProfileController> {
  const InsuranceView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchInsuranceCompanies();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('बीमा कम्पनीहरू'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoadingInsurance.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.insuranceCompanies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 64,
                  color: Colors.amber,
                ),
                const SizedBox(height: 16),
                const Text(
                  'कुनै बीमा कम्पनी फेला परेन',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.fetchInsuranceCompanies,
                  child: const Text('पुन: प्रयास गर्नुहोस्'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              // Toggle expansion state and fetch plans if needed
              controller.toggleInsuranceExpansion(index);
            },
            elevation: 2,
            dividerColor: Colors.grey[300],
            expandedHeaderPadding: const EdgeInsets.all(8),
            children: controller.insuranceCompanies.asMap().entries.map((
              entry,
            ) {
              final index = entry.key;
              final company = entry.value;

              return ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Icon(Icons.shield, color: Colors.green.shade700),
                    ),
                    title: Text(
                      company.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.phone,
                        'सम्पर्क',
                        company.contactInfo,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.language,
                        'वेबसाइट',
                        company.websiteUrl,
                      ),
                      const SizedBox(height: 16),

                      // Insurance plans section
                      const Text(
                        'बीमा योजनाहरू',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Show plans or loading indicator
                      Obx(() {
                        // Check if plans are loading
                        if (controller.isLoadingPlans[company.id]?.value ??
                            false) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        // Get plans for this company
                        final plans =
                            controller.insurancePlansMap[company.id] ??
                            <InsurancePlan>[].obs;

                        if (plans.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'कुनै योजना उपलब्ध छैन',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          );
                        }

                        // Show plans
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: plans.length,
                          itemBuilder: (context, idx) {
                            return _buildPlanCard(plans[idx]);
                          },
                        );
                      }),
                    ],
                  ),
                ),
                isExpanded: controller.expandedInsuranceIndices.contains(index),
                canTapOnHeader: true,
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(InsurancePlan plan) {
    final RxBool isLoading = false.obs;
    final RxBool isApplied = false.obs;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _getCategoryIcon(plan.category),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    plan.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      plan.category,
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    plan.category,
                    style: TextStyle(
                      color: _getCategoryColor(plan.category),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(plan.description, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 12),

            Obx(() {
              if (isLoading.value) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('प्रक्रिया हुँदैछ...'),
                      ],
                    ),
                  ),
                );
              } else if (isApplied.value) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      isApplied.value = false;
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('हटाउनुहोस्'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                );
              } else {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Set loading state
                      isLoading.value = true;

                      // Wait for 3 seconds
                      await Future.delayed(const Duration(seconds: 3));

                      // Update state to applied
                      isLoading.value = false;
                      isApplied.value = true;
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('आवेदन गर्नुहोस्'), // Apply
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    IconData iconData;
    Color color;

    switch (category.toLowerCase()) {
      case 'livestock':
        iconData = Icons.pets;
        color = Colors.brown;
        break;
      case 'crops':
        iconData = Icons.grass;
        color = Colors.green;
        break;
      case 'mixed':
        iconData = Icons.category;
        color = Colors.purple;
        break;
      default:
        iconData = Icons.shield;
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 20),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'livestock':
        return Colors.brown;
      case 'crops':
        return Colors.green;
      case 'mixed':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}
