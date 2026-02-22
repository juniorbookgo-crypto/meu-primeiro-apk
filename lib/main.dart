import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi Tool PRO',
      theme: darkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(
        toggleTheme: () {
          setState(() {
            darkMode = !darkMode;
          });
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  const HomePage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {"title": "Calculadora", "page": const CalculatorPage()},
      {"title": "IMC", "page": const IMCPage()},
      {"title": "Senha", "page": const PasswordPage()},
      {"title": "Conversor Temp", "page": const TempPage()},
      {"title": "QR Code", "page": const QRPage()},
      {"title": "Notas", "page": const NotesPage()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi Tool PRO"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => tools[index]["page"] as Widget),
              );
            },
            child: Text(
              tools[index]["title"].toString(),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? bannerAd;

  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX", // COLOQUE SEU ID
      listener: BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return bannerAd == null
        ? const SizedBox()
        : SizedBox(
            height: 50,
            child: AdWidget(ad: bannerAd!),
          );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final controller = TextEditingController();
  String result = "";

  void calculate() {
    try {
      result = controller.text;
      setState(() {});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: controller),
            ElevatedButton(onPressed: calculate, child: const Text("Calcular")),
            Text(result, style: const TextStyle(fontSize: 24))
          ],
        ),
      ),
    );
  }
}

class IMCPage extends StatefulWidget {
  const IMCPage({super.key});

  @override
  State<IMCPage> createState() => _IMCPageState();
}

class _IMCPageState extends State<IMCPage> {
  final peso = TextEditingController();
  final altura = TextEditingController();
  String resultado = "";

  void calcular() {
    double p = double.parse(peso.text);
    double a = double.parse(altura.text);
    double imc = p / (a * a);
    resultado = "IMC: ${imc.toStringAsFixed(2)}";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IMC")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: peso, decoration: const InputDecoration(labelText: "Peso")),
            TextField(controller: altura, decoration: const InputDecoration(labelText: "Altura")),
            ElevatedButton(onPressed: calcular, child: const Text("Calcular")),
            Text(resultado, style: const TextStyle(fontSize: 24))
          ],
        ),
      ),
    );
  }
}

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  String senha = "";

  void gerar() {
    const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    Random rnd = Random();
    senha = String.fromCharCodes(
        Iterable.generate(12, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gerador de Senha")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(senha, style: const TextStyle(fontSize: 20)),
            ElevatedButton(onPressed: gerar, child: const Text("Gerar Senha"))
          ],
        ),
      ),
    );
  }
}

class TempPage extends StatefulWidget {
  const TempPage({super.key});

  @override
  State<TempPage> createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {
  final celsius = TextEditingController();
  String resultado = "";

  void converter() {
    double c = double.parse(celsius.text);
    double f = (c * 9 / 5) + 32;
    resultado = "$f °F";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conversor °C → °F")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: celsius),
            ElevatedButton(onPressed: converter, child: const Text("Converter")),
            Text(resultado, style: const TextStyle(fontSize: 24))
          ],
        ),
      ),
    );
  }
}

class QRPage extends StatelessWidget {
  const QRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Code")),
      body: const Center(
        child: Text("Implementar pacote qr_flutter depois"),
      ),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bloco de Notas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: controller,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ),
    );
  }
}