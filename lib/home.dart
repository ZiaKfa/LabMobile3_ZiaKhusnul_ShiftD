import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: no_logic_in_create_state
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var username;
  List<String> pokemons = [];

  final TextEditingController _pokemonController = TextEditingController();

  _savePokemons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('pokemons', pokemons);
  }

  _loadPokemons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pokemons = prefs.getStringList('pokemons') ?? [];
    setState(() {
      
    });
  }
  
  _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadUsername();
    _loadPokemons();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            const Text('List Pokemon'),
            const SizedBox(height: 20),
            Text('Selamat Datang Trainer $username!'),
            const SizedBox(height: 20),
            TextField(
              controller: _pokemonController,
              decoration: const InputDecoration(
                hintText: 'Masukkan Nama Pokemon',
              ),
              onSubmitted: (value) {
                setState(() {
                  pokemons.add(value);
                  _savePokemons();
                  _pokemonController.clear();
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: pokemons.length,
                itemBuilder: (context, index) {
                    return Card(
                    child: ListTile(
                      title: Text(pokemons[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            pokemons.removeAt(index);
                            _savePokemons();
                          });
                        },
                      ),
                    ),
                    );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}