import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

class EvaluationsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Evaluations Chart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double containerWidth = constraints.maxWidth * 0.9; // 90% de la largeur disponible
              return Column(
                children: [
                  _buildChoiceSelectors(),
                  _buildBarChartContainer(containerWidth),
                  _buildPieChartContainer('La présentation du cours', 0.7, 0.3, containerWidth),
                  _buildPieChartContainer('La pédagogie adoptée', 0.8, 0.2, containerWidth),
                  _buildPieChartContainer(
                    'L\'adaptation des activités d\'apprentissage aux objectifs des cours',
                    0.6,
                    0.4,
                    containerWidth,
                  ),
                  _buildPieChartContainer('Atteinte des acquis d\'apprentissage', 0.9, 0.1, containerWidth),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceSelectors() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildDropdown('Semestre', ['Semestre 1', 'Semestre 2']),
          SizedBox(height: 8.0),
          _buildDropdown('Classe', ['Classe 1', 'Classe 2', 'Classe 3']),
          SizedBox(height: 8.0),
          _buildDropdown('Matière', ['Matière 1', 'Matière 2', 'Matière 3']),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Implémentation de l'action de soumission
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String title, List<String> options) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<String>(
          value: options[0],
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.red,
          ),
          onChanged: (String? newValue) {},
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBarChartContainer(double width) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'La charge de travail en heures associée au cours',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                barGroups: _createSampleBarData(),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartContainer(String title, double satisfied, double notSatisfied, double width) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          SizedBox(
            height: 200,
            child: CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 20.0,
              percent: satisfied,
              center: Text(
                '${(satisfied * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              progressColor: Colors.red,
              backgroundColor: Colors.grey,
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Satisfait: ${(satisfied * 100).toStringAsFixed(1)}% / Non Satisfait: ${(notSatisfied * 100).toStringAsFixed(1)}%',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _createSampleBarData() {
    final data = [
      BarChartModel('Cours 1', 5),
      BarChartModel('Cours 2', 7),
      BarChartModel('Cours 3', 6),
      BarChartModel('Cours 4', 8),
    ];

    return data.map((BarChartModel eval) {
      return BarChartGroupData(
        x: data.indexOf(eval),
        barRods: [
          BarChartRodData(
            toY: eval.charge.toDouble(), // Mise à jour ici avec toY
             color: Colors.blue,
          ),
        ],
      );
    }).toList();
  }
}

class BarChartModel {
  final String cours;
  final int charge;

  BarChartModel(this.cours, this.charge);
}
