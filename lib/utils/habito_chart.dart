import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HabitoProgresoChart extends StatelessWidget {
  final List<HabitData> data;

  const HabitoProgresoChart({required this.data});

  @override
  Widget build(BuildContext context) {
    print('Contenido de data:');
    for (int i = 0; i < data.length; i++) {
      print('Mes: ${data[i].year}, Conteo: ${data[i].sales}');
    }
    return Center(
      child: Container(
        child: SfCartesianChart(
          // Initialize category axis
          primaryXAxis: CategoryAxis(),
          series: <LineSeries<HabitData, String>>[
            LineSeries<HabitData, String>(
              dataSource: data,
              xValueMapper: (HabitData habitData, _) => habitData.year,
              yValueMapper: (HabitData habitData, _) => habitData.sales,
            )
          ],
        ),
      ),
    );
  }
}

class HabitData {
  final String year;
  final int sales;

  HabitData(this.year, this.sales);
}
