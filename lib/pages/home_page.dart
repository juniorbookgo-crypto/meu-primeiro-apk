import 'package:flutter/material.dart';
import '../services/historical_service.dart';
import '../services/hybrid_engine.dart';
import '../models/result_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HistoricalService _historicalService = HistoricalService();
  final HybridEngine _hybridEngine = HybridEngine();

  Map<String, dynamic>? prediction;

  void generatePrediction() {
    List<ResultModel> history = _historicalService.getMockResults();
    final result = _hybridEngine.generatePrediction(history);

    setState(() {
      prediction = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Motor Híbrido - Loteria"),
        centerTitle: true,
      ),
      body: Center(
        child: prediction == null
            ? ElevatedButton(
                onPressed: generatePrediction,
                child: const Text("Gerar Previsão"),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Milhar: ${prediction!['milhar']}",
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(
                    "Dezena: ${prediction!['dezena']}",
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(
                    "Grupo: ${prediction!['grupo']}",
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: generatePrediction,
                    child: const Text("Gerar Nova Previsão"),
                  ),
                ],
              ),
      ),
    );
  }
}