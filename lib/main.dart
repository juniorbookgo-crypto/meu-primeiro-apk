import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const CaixaPremiumApp());
}

class CaixaPremiumApp extends StatelessWidget {
  const CaixaPremiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String loteria = "megasena";
  List<dynamic> historico = [];
  Map<int, int> frequencia = {};
  Map<int, int> atraso = {};
  Map<int, double> score = {};
  List<List<int>> palpites = [];
  bool carregando = true;
  bool premium = true;

  @override
  void initState() {
    super.initState();
    atualizarAutomaticamente();
  }

  Future<void> atualizarAutomaticamente() async {
    await carregarDados();
    gerarIA();
    setState(() => carregando = false);
  }

  Future<void> carregarDados() async {
    historico.clear();
    frequencia.clear();
    atraso.clear();
    score.clear();

    final urlBase =
        "https://servicebus2.caixa.gov.br/portaldeloterias/api/$loteria";

    final ultimoResponse =
        await http.get(Uri.parse(urlBase), headers: {"Accept": "application/json"});

    final ultimo = json.decode(ultimoResponse.body);
    int numeroAtual = ultimo['numero'];

    int limite = 250;

    for (int i = 0; i < limite; i++) {
      int numero = numeroAtual - i;
      if (numero <= 0) break;

      final response = await http.get(
          Uri.parse("$urlBase/$numero"),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        final concurso = json.decode(response.body);
        historico.add(concurso);

        for (var dez in concurso['listaDezenas']) {
          int n = int.parse(dez);
          frequencia[n] = (frequencia[n] ?? 0) + 1;
        }
      }

      await Future.delayed(const Duration(milliseconds: 20));
    }

    calcularAtraso();
    calcularScore();
  }

  void calcularAtraso() {
    Map<int, int> ultimoSorteio = {};

    for (int i = 0; i < historico.length; i++) {
      for (var dez in historico[i]['listaDezenas']) {
        int n = int.parse(dez);
        ultimoSorteio[n] ??= i;
      }
    }

    for (int i = 1; i <= 60; i++) {
      atraso[i] = ultimoSorteio[i] ?? historico.length;
    }
  }

  void calcularScore() {
    for (int i = 1; i <= 60; i++) {
      double freq = (frequencia[i] ?? 0).toDouble();
      double atr = (atraso[i] ?? 0).toDouble();

      double pesoRecencia = freq * 0.7;
      double pesoAtraso = atr * 0.3;

      score[i] = pesoRecencia + pesoAtraso;
    }
  }

  void gerarIA() {
    palpites.clear();
    Random rand = Random();

    List<int> ordenado = score.keys.toList()
      ..sort((a, b) => score[b]!.compareTo(score[a]!));

    for (int p = 0; p < 3; p++) {
      Set<int> jogo = {};

      while (jogo.length < 6) {
        int candidato = ordenado[rand.nextInt(20)];
        jogo.add(candidato);
      }

      // Balanceamento par/ímpar
      int pares = jogo.where((n) => n % 2 == 0).length;
      if (pares < 2 || pares > 4) continue;

      palpites.add(jogo.toList()..sort());
    }

    monteCarlo();
  }

  void monteCarlo() {
    Random rand = Random();
    for (int i = 0; i < 10000; i++) {
      rand.nextInt(60);
    }
  }

  Future<void> exportarPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text("Relatório Mega Sena Premium"),
              pw.SizedBox(height: 20),
              ...palpites.map((p) => pw.Text(p.join(" - "))),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  List<BarChartGroupData> gerarGrafico() {
    return frequencia.entries.take(10).map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(toY: e.value.toDouble()),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        title: const Text("Mega Sena Premium IA"),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("🎯 Palpites IA",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...palpites.map((p) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(p.join(" - "),
                              style: const TextStyle(fontSize: 18)),
                        ),
                      )),
                  const SizedBox(height: 20),
                  const Text("📊 Top 10 Frequência",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 250,
                    child: BarChart(
                      BarChartData(
                        barGroups: gerarGrafico(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: exportarPDF,
                    child: const Text("Exportar PDF"),
                  )
                ],
              ),
            ),
    );
  }
}