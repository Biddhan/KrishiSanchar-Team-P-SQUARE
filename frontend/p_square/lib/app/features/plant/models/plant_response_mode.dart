class DiseasePredictionResponse {
  final String predictedClass;
  final double confidence;
  final Recommendation recommendation;

  DiseasePredictionResponse({
    required this.predictedClass,
    required this.confidence,
    required this.recommendation,
  });

  factory DiseasePredictionResponse.fromJson(Map<String, dynamic> json) {
    return DiseasePredictionResponse(
      predictedClass: json['predicted_class'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      recommendation: Recommendation.fromJson(json['recommendation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'predicted_class': predictedClass,
      'confidence': confidence,
      'recommendation': recommendation.toJson(),
    };
  }
}

class Recommendation {
  final List<String> disease;
  final List<String> causes;
  final List<String> symptoms;
  final List<String> management;

  Recommendation({
    required this.disease,
    required this.causes,
    required this.symptoms,
    required this.management,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      disease: List<String>.from(json['disease']),
      causes: List<String>.from(json['causes']),
      symptoms: List<String>.from(json['symptoms']),
      management: List<String>.from(json['management']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease': disease,
      'causes': causes,
      'symptoms': symptoms,
      'management': management,
    };
  }
}
