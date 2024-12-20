import 'dart:convert';
import 'package:flutter/material.dart';
import '../api/reclamation_service.dart';
import '../api/auth_service.dart';
import 'package:http/http.dart' as http;

class ReclamationsScreen extends StatefulWidget {
  const ReclamationsScreen({Key? key}) : super(key: key);

  @override
  _ReclamationsScreenState createState() => _ReclamationsScreenState();
}

class _ReclamationsScreenState extends State<ReclamationsScreen> {
  final ReclamationService _service = ReclamationService();
  List<Map<String, dynamic>> _data = [];

  // Filter variables
  String _selectedEtat = 'All'; // Options: 'All', 'Traité', 'Non traité'
  String _selectedYear = 'All'; // Options: 'All', '2024', '2025', etc.

  @override
  void initState() {
    super.initState();
    _fetchReclamations();
  }

  Future<void> _fetchReclamations() async {
  try {
    String? token = await AuthService.getToken();

    if (token != null) {
      List<Map<String, dynamic>> reclamations = await _service.getReclamationsByEnseignant(token);

      List<Map<String, dynamic>> filteredReclamations = reclamations.where((reclamation) {
        bool matchesEtat = _selectedEtat == 'All' || reclamation['Etat'] == _selectedEtat;
        bool matchesYear = _selectedYear == 'All' || (reclamation['Annee']?.toString() ?? '') == _selectedYear;
        return matchesEtat && matchesYear;
      }).toList();

      setState(() {
        _data = filteredReclamations;
      });
    } else {
      print('Token is null. Unable to fetch reclamations.');
    }
  } catch (e) {
    print('Error fetching reclamations: $e');
  }
}


  Future<void> _updateReclamationResponse(String id, String newResponse) async {
    try {
      String? token = await AuthService.getToken();
      if (token != null) {
        final http.Response httpResponse = await http.put(
          Uri.parse('http://localhost:5000/api/reclamations/$id/repondre'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'Reponse_Reclamation': newResponse,
          }),
        );
        if (httpResponse.statusCode == 200) {
          // Update the response locally
          setState(() {
            _data = _data.map((item) {
              if (item['_id'] == id) {
                item['response'] = newResponse;
              }
              return item;
            }).toList();
          });
        } else {
          throw Exception('Failed to update response');
        }
      }
    } catch (e) {
      print('Error updating response: $e');
    }
  }

  Future<void> _deleteReclamation(String id, int index) async {
    try {
      String? token = await AuthService.getToken();
      if (token != null) {
        final http.Response httpResponse = await http.delete(
          Uri.parse('http://localhost:5000/api/reclamations/$id'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        if (httpResponse.statusCode == 200) {
          setState(() {
            _data.removeAt(index);
          });
        } else {
          throw Exception('Failed to delete reclamation');
        }
      }
    } catch (e) {
      print('Error deleting reclamation: $e');
    }
  }

  Future<void> _showResponseDialog(int index) async {
    TextEditingController responseController = TextEditingController();
    String currentResponse = _data[index]['response'] ?? ''; // Use empty string if response is null

    responseController.text = currentResponse; // Pre-fill with existing response if any

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Response'),
          content: TextField(
            controller: responseController,
            decoration: const InputDecoration(labelText: 'Response'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _updateReclamationResponse(_data[index]['_id'], responseController.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  title: const Text(
    'Reclamations',
    style: TextStyle(color: Colors.white), // Set the text color to white
  ),
  backgroundColor: Colors.red[900], // AppBar background color
  iconTheme: const IconThemeData(color: Colors.white), // Icon color
  elevation: 0, // Remove shadow for a cleaner look (optional)
),

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Filters
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedEtat,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedEtat = newValue!;
                              _fetchReclamations(); // Refresh data based on new filter
                            });
                          },
                          items: <String>['All', 'Traité', 'Non traité']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Etat',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedYear,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedYear = newValue!;
                              _fetchReclamations(); // Refresh data based on new filter
                            });
                          },
                          items: <String>['All','2023','2024', '2025', '2026', '2027']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Year',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical, // Added vertical scroll
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(0.7)),
                        dataRowColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(0.4)),
                        columns: const [
                          DataColumn(label: Text('Year', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('ID', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Full name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Class', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Type', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('State', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Teacher', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Module code', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Module', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Claim date', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Claim text', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Response', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ],
                        rows: List<DataRow>.generate(_data.length, (index) {
                          return DataRow(
                            cells: [
                              DataCell(Text((_data[index]['Annee']?.toString() ?? ''), style: const TextStyle(color: Colors.white))),
                              DataCell(Text((_data[index]['etudiantId'] ?? ''), style: const TextStyle(color: Colors.white))),
                              DataCell(Text((_data[index]['nomPrenom'] ?? ''), style: const TextStyle(color: Colors.white))),
                              DataCell(Text((_data[index]['Classe']?.toString() ?? ''), style: const TextStyle(color: Colors.white))),
                              DataCell(Text((_data[index]['Type_Reclamation'] ?? ''), style: const TextStyle(color: Colors.white))),
                              DataCell(Text((_data[index]['Etat'] ?? ''), style: const TextStyle(color: Colors.white))),
                              DataCell(Text((_data[index]['enseignant']?.toString() ?? ''), style: const TextStyle(color: Colors.white))),
                              DataCell(Text((_data[index]['Code_module'] ?? ''), style: const TextStyle(color: Colors.white))),
                              DataCell(Text((_data[index]['Module']?.toString() ?? ''), style: const TextStyle(color: Colors.white))),
                              DataCell(Text((_data[index]['date_reclamation']?.toString() ?? ''), style: const TextStyle(color: Colors.white))),
                              DataCell(Text((_data[index]['Text_Reclamation'] ?? ''), style: const TextStyle(color: Colors.white))),
                              DataCell(
                                GestureDetector(
                                  onTap: () => _showResponseDialog(index),
                                  child: Text(
                                    (_data[index]['response'] ?? 'Tap to add'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.white),
                                      onPressed: () => _deleteReclamation(_data[index]['_id'], index),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
