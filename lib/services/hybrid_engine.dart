import '../models/result_model.dart';

class HybridEngine {
  Map<String, dynamic> generatePrediction(List<ResultModel> history) {
    if (history.isEmpty) {
      return {};
    }

    int lastMilhar = history.last.milhar;
    int predictedMilhar = (lastMilhar + 123) % 10000;

    return {
      'milhar': predictedMilhar,
      'dezena': predictedMilhar % 100,
      'grupo': (predictedMilhar % 25) + 1,
    };
  }
}