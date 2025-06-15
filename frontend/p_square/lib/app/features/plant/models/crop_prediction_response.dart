class CropPredictionResponse {
  final String crop;
  final double urea;
  final double dap;
  final double potash;

  CropPredictionResponse({
    required this.crop,
    required this.urea,
    required this.dap,
    required this.potash,
  });

  factory CropPredictionResponse.fromJson(Map<String, dynamic> json) {
    return CropPredictionResponse(
      crop: json['Crops'] as String,
      urea: json['Urea (Nitrogen)'] as double,
      dap: json['DAP (Phosphate)'] as double,
      potash: json['Potash (K₂O)'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Crops': crop,
      'Urea (Nitrogen)': urea,
      'DAP (Phosphate)': dap,
      'Potash (K₂O)': potash,
    };
  }
}
