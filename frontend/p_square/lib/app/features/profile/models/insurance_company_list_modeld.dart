import 'package:p_square/app/features/profile/models/insurance_company_model.dart';

class InsuranceCompanyList {
  final List<InsuranceCompany> companies;

  InsuranceCompanyList({required this.companies});

  factory InsuranceCompanyList.fromJson(List<dynamic> json) {
    return InsuranceCompanyList(
      companies: json
          .map((company) => InsuranceCompany.fromJson(company as Map<String, dynamic>))
          .toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return companies.map((company) => company.toJson()).toList();
  }
}