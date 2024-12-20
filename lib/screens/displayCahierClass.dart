import 'package:flutter/material.dart';
import '../api/cachierdeclass_service.dart';
import '../screens/DetailsCahierClass.dart';
import '../screens/create_cahier_classe.dart';

class DisplayCahierClass extends StatefulWidget {
  const DisplayCahierClass({Key? key}) : super(key: key);

  @override
  State<DisplayCahierClass> createState() => _DisplayCahierClassState();
}

class _DisplayCahierClassState extends State<DisplayCahierClass> {
  late CahierClasseService _service;
  late Future<List<dynamic>> _futureCahierClasses;
  List<dynamic> _allCahierClasses = [];
  List<dynamic> _filteredCahierClasses = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _service = CahierClasseService(baseUrl: 'http://localhost:5000');
    _futureCahierClasses = _service.getCahierClasses();
    _futureCahierClasses.then((data) {
      setState(() {
        _allCahierClasses = data;
        _filteredCahierClasses = data;
      });
    });
  }

  void _filterCahierClasses(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCahierClasses = _allCahierClasses
          .where((cahier) =>
              cahier['titre_seance']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              cahier['contenu']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToDetailsCahierClass(Map<String, dynamic> record) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsCahierClass(record: record),
      ),
    );
  }

  void _navigateToCahierdeclassForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCahierClasse(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cahier de Classe'),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _navigateToCahierdeclassForm,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: _filterCahierClasses,
                decoration: InputDecoration(
                  hintText: 'Search..',
                  prefixIcon: const Icon(Icons.search, color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            Expanded(
              child: _buildCahierClassesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCahierClassesList() {
    return FutureBuilder<List<dynamic>>(
      future: _futureCahierClasses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (_filteredCahierClasses.isEmpty) {
          return const Center(child: Text('No Cahier de Classe found.'));
        } else {
          return ListView.builder(
            itemCount: _filteredCahierClasses.length,
            itemBuilder: (context, index) {
              final cahier = _filteredCahierClasses[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                elevation: 5,
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        cahier['titre_seance'] ?? 'No Title',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Date: ${cahier['date']?.toString().substring(0, 10) ?? 'No Date'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Horaire: ${cahier['horaire_seance'] ?? 'No Time'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Contenu: ${cahier['contenu'] ?? 'No Content'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Remarque: ${cahier['remarque'] ?? 'No Remarks'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Semestre: ${cahier['semestre'] ?? 'No Semester'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _navigateToDetailsCahierClass(cahier),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Show Details',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
