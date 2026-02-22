import '../models/result_model.dart';

class HistoricalService {
  List<ResultModel> getMockResults() {
    return [
      ResultModel(
        date: DateTime(2026, 2, 15),
        milhar: 1234,
        dezena: 34,
        grupo: 9,
      ),
      ResultModel(
        date: DateTime(2026, 2, 16),
        milhar: 5678,
        dezena: 78,
        grupo: 20,
      ),
      ResultModel(
        date: DateTime(2026, 2, 17),
        milhar: 9012,
        dezena: 12,
        grupo: 3,
      ),
    ];
  }
}