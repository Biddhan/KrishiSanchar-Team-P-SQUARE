import 'package:p_square/app/features/profile/models/insurance_plan_model.dart';

class InsurancePlanList {
  final List<InsurancePlan> plans;

  InsurancePlanList({required this.plans});

  factory InsurancePlanList.fromJson(List<dynamic> json) {
    return InsurancePlanList(
      plans: json
          .map((plan) => InsurancePlan.fromJson(plan as Map<String, dynamic>))
          .toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return plans.map((plan) => plan.toJson()).toList();
  }
}
