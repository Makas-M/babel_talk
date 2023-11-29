import 'dart:convert';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:translator/translator.dart';

//importar paginas
import 'package:babel_talk/database_helper.dart';
import 'package:babel_talk/list_quote.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String quote = "";
  String author = "";
  String titulo = "";
  String botao = "";
  String translatedQuote = "";
  String selectedCountry = 'PT';

  @override
  void initState() {
    super.initState();
    fetchQuote();

    WidgetsFlutterBinding.ensureInitialized();
    DatabaseHelper.initializeDatabase();
  }

  Future<void> fetchQuote() async {
    final response =
        await http.get(Uri.parse("https://api.quotable.io/random"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        quote = data['content'];
        author = data['author'];

        translateQuote();
      });
    } else {
      if (kDebugMode) {
        print(
            "Erro ao obter a citação. Código de status: ${response.statusCode}");
      }
    }
  }

  //traduzir
  Future<void> translateQuote() async {
    final translator = GoogleTranslator();
    if (selectedCountry == 'PT') {
      Translation translation = await translator.translate(quote, to: 'pt');
      setState(() {
        quote = translation.text;
        titulo = 'Citação do dia';
        botao = 'NOVA CITAÇÃO';
      });
    } else {
      Translation translation = await translator.translate(quote, to: 'en');
      setState(() {
        quote = translation.text;
        titulo = 'Quote of the day';
        botao = 'NEW QUOTE';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Babel Talk',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          DropdownButton<String>(
            value: selectedCountry,
            onChanged: (String? value) {
              setState(() {
                selectedCountry = value!;
                translateQuote();
              });
            },
            underline: Container(
              height: 0,
            ),
            items: [
              'PT',
              'US',
            ].map((String countryCode) {
              return DropdownMenuItem<String>(
                value: countryCode,
                child: CountryFlag.fromCountryCode(
                  countryCode,
                  height: 20,
                  width: 30,
                ),
              );
            }).toList(),
          ),
          IconButton(
              onPressed: () {
                Share.share('$quote \n $author \n \n #babeltalk');
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
                Text(
                  titulo,
                  style: const TextStyle(
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
                  child: Text(botao),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final database = await DatabaseHelper.initializeDatabase();
                    await DatabaseHelper.insertData(database, quote);
                  },
                  child: const Text('Salvar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DataListPage()),
                    );
                  },
                  child: const Text('Ver Dados'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
