import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class DataVisualizationScreen extends StatelessWidget {
  final List<List<String>> data;

  DataVisualizationScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = _getChartData();
    // double plantHealth = _predictPlantHealth(chartData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Data Visualization'),
      ),
      body: Scrollbar(
        thumbVisibility: true, // Shows the scrollbar thumb when scrolling
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSingleParameterChart(chartData, 'Temperature'),
              _buildSingleParameterChart(chartData, 'Humidity'),
              _buildSingleParameterChart(chartData, 'Pressure'),
              _buildSingleParameterChart(chartData, 'Gas'),
              _buildSingleParameterChart(chartData, 'PM2.5'),
              _buildSingleParameterChart(chartData, 'PM10'),
              _buildCombinedChart(chartData),
              // _buildPlantHealthIndicator(plantHealth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleParameterChart(
      List<ChartData> chartData, String parameter) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        height: 300,
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat('MM/dd HH:mm'),
            intervalType: DateTimeIntervalType.auto,
          ),
          primaryYAxis: NumericAxis(title: AxisTitle(text: parameter)),
          tooltipBehavior: TooltipBehavior(enable: true),
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true,
            enableDoubleTapZooming: true,
            enablePanning: true,
          ),
          series: <ChartSeries>[
            LineSeries<ChartData, DateTime>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.timestamp,
              yValueMapper: (ChartData data, _) =>
                  data.getParameterValue(parameter),
              name: parameter,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedChart(List<ChartData> chartData) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        height: 400,
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat('MM/dd HH:mm'),
            intervalType: DateTimeIntervalType.auto,
          ),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'Values')),
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: true),
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true,
            enableDoubleTapZooming: true,
            enablePanning: true,
          ),
          series: _getChartSeries(chartData),
        ),
      ),
    );
  }

  Widget _buildPlantHealthIndicator(double health) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text('Predicted Plant Health',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: health / 100,
            minHeight: 30,
            backgroundColor: Colors.red,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          SizedBox(height: 5),
          Text('${health.toStringAsFixed(2)}%', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  List<ChartSeries<ChartData, DateTime>> _getChartSeries(
      List<ChartData> chartData) {
    return [
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.temperature,
        name: 'Temperature',
      ),
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.humidity,
        name: 'Humidity',
      ),
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.pressure,
        name: 'Pressure',
      ),
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.gas,
        name: 'Gas',
      ),
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.pm25,
        name: 'PM2.5',
      ),
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.timestamp,
        yValueMapper: (ChartData data, _) => data.pm10,
        name: 'PM10',
      ),
    ];
  }

  List<ChartData> _getChartData() {
    List<ChartData> chartData = [];
    for (var row in data.skip(1)) {
      // Skip header row
      if (row.length >= 7) {
        DateTime timestamp = DateTime.parse(row[0]);
        chartData.add(ChartData(
          timestamp: timestamp,
          temperature: double.tryParse(row[1]) ?? 0,
          humidity: double.tryParse(row[2]) ?? 0,
          pressure: double.tryParse(row[3]) ?? 0,
          gas: double.tryParse(row[4]) ?? 0,
          pm25: double.tryParse(row[5]) ?? 0,
          pm10: double.tryParse(row[6]) ?? 0,
        ));
      }
    }
    return chartData;
  }

  // double _predictPlantHealth(List<ChartData> chartData) {
  //   final features = <List<double>>[];
  //   final targets = <double>[];

  //   for (var data in chartData) {
  //     features.add([
  //       data.temperature,
  //       data.humidity,
  //       data.pressure,
  //       data.gas,
  //       data.pm25,
  //       data.pm10,
  //     ]);
  //     targets.add((data.temperature * 0.2 +
  //         data.humidity * 0.3 +
  //         (100 - data.pm25) * 0.25 +
  //         (100 - data.pm10) * 0.25));
  //   }

  //   // Convert features and targets to DataFrame
  //   final featureFrame = DataFrame.fromMatrix(features);
  //   final targetFrame = DataFrame.fromMatrix(targets.map((e) => [e]).toList());

  //   // Create and train the regression model
  //   final regression = LinearRegressor(
  //     featureFrame,
  //     targetFrame,
  //     fitIntercept: true,
  //     interceptScale: 1.0,
  //   );

  //   // Predict health based on the latest data point
  //   final latestFeatures = [features.last];
  //   final latestFeatureFrame = DataFrame.fromMatrix(latestFeatures);
  //   final prediction = regression.predict(latestFeatureFrame);

  //   return prediction.rows.first.first.clamp(0, 100);
  // }
}

class ChartData {
  final DateTime timestamp;
  final double temperature;
  final double humidity;
  final double pressure;
  final double gas;
  final double pm25;
  final double pm10;

  ChartData({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.gas,
    required this.pm25,
    required this.pm10,
  });

  double getParameterValue(String parameter) {
    switch (parameter) {
      case 'Temperature':
        return temperature;
      case 'Humidity':
        return humidity;
      case 'Pressure':
        return pressure;
      case 'Gas':
        return gas;
      case 'PM2.5':
        return pm25;
      case 'PM10':
        return pm10;
      default:
        return 0;
    }
  }
}
