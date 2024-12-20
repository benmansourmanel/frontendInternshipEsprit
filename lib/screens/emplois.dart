import 'package:flutter/material.dart';

class EmploisPage extends StatefulWidget {
  const EmploisPage({Key? key}) : super(key: key);

  @override
  _EmploisPageState createState() => _EmploisPageState();
}

class _EmploisPageState extends State<EmploisPage> {
  final List<Map<String, String>> _data = List.generate(
    10,
    (index) => {
      'module': 'Module ${index + 1}',
      'class': 'Class ${index + 1}',
      'nbr_heurs': 'Nbr heurs ${index + 1}',
      'semestre': 'Semestre ${index + 1}',
      'charge_p1': 'Charge P1 ${index + 1}',
      'charge_p2': 'Charge P2 ${index + 1}',
      'cc': '0',
      'tp': '0',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emplois du temps',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[900],
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCard(
                        icon: Icons.access_time,
                        title: 'Semestre I',
                        value: '50 hours',
                        color: Colors.grey,
                      ),
                      _buildInfoCard(
                        icon: Icons.access_time_filled,
                        title: 'Semestre II',
                        value: '80 hours',
                        color: Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
  child: const Text(
    'Votre charge horaire',
    style: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
),

                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black.withOpacity(0.7),
                      ),
                      dataRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black.withOpacity(0.4),
                      ),
                      columns: const [
                        DataColumn(label: Text('Module', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Class', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Nbr heurs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Semestre', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Charge P1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Charge P2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('CC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('TP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      rows: List<DataRow>.generate(
                        _data.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(Text(_data[index]['module']!, style: const TextStyle(color: Colors.white))),
                            DataCell(Text(_data[index]['class']!, style: const TextStyle(color: Colors.white))),
                            DataCell(Text(_data[index]['nbr_heurs']!, style: const TextStyle(color: Colors.white))),
                            DataCell(Text(_data[index]['semestre']!, style: const TextStyle(color: Colors.white))),
                            DataCell(Text(_data[index]['charge_p1']!, style: const TextStyle(color: Colors.white))),
                            DataCell(Text(_data[index]['charge_p2']!, style: const TextStyle(color: Colors.white))),
                            DataCell(_buildRadioButton(index, 'cc')),
                            DataCell(_buildRadioButton(index, 'tp')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(int index, String type) {
    return Radio<String>(
      value: '1',
      groupValue: type == 'cc' ? _data[index]['cc'] : _data[index]['tp'],
      onChanged: (value) {
        setState(() {
          if (type == 'cc') {
            _data[index]['cc'] = value!;
          } else {
            _data[index]['tp'] = value!;
          }
        });
      },
      activeColor: Colors.white,
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
