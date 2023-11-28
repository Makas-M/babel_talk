import 'dart:convert';
import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:country_pickers/country_pickers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String quote = "";
  String author = "";
  Locale currentLocale = Locale('en', 'US');
  String translatedQuote = "";

  @override
  void initState() {
    super.initState();
    fetchQuote();
    translate();
  }

  Future<void> fetchQuote() async {
    final response =
        await http.get(Uri.parse("https://api.quotable.io/random"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        quote = data['content'];
        author = data['author'];
      });
    } else {
      print(
          "Erro ao obter a citação. Código de status: ${response.statusCode}");
    }
  }

  Future<void> translate() async {
    // Código para traduzir a citação
  }
  void _changeLanguage(Locale newLocale) {
    setState(() {
      currentLocale = newLocale;
    });
  }

  void _onCountryChanged(String? countryCode) {
    // Implemente a lógica para tratar a mudança de país conforme necessário
    if (countryCode != null) {
      print('País selecionado: $countryCode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          //Adicionar Icon de Linguas Aqui!

          IconButton(
              onPressed: () {
                Share.share('textoParaCompartilhar');
              },
              icon: const Icon(Icons.share)),
        ],
      ),
      body: Container(
        //TODO: Colocar opcao de mudar a cor de darkmode para light
        color: const Color.fromARGB(255, 27, 27, 27),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Quote of the day",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  child: Text(
                    quote.isNotEmpty ? quote : "...",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  author.isNotEmpty ? author : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: fetchQuote,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red, //texto
                    backgroundColor: Colors.black, //cor do texto
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Borda arredondada
                      side: const BorderSide(color: Colors.red), // Cor da borda
                    ),
                  ),
                  child: const Text("NEW QUOTE"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
