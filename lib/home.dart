import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'stats.dart';

class DataScreen extends StatefulWidget {
  final String credentials;
  final String spreadsheetId;

  const DataScreen(
      {Key? key, required this.credentials, required this.spreadsheetId})
      : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  late List<List<String>> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final gsheets = GSheets(widget.credentials);
    final ss = await gsheets.spreadsheet(widget.spreadsheetId);
    var sheet = ss.worksheetByTitle("Sheet1");
    final rows = await sheet!.values.allRows();

    setState(() {
      _data = rows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sheets Data'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DataVisualizationScreen(data: _data),
                ),
              );
            },
            child: Text('View Visualization'),
          ),
          Expanded(
            child: _data.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      final row = _data[index];
                      return ListTile(
                        title: Text(row.join(', ')),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
