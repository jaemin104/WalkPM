import 'package:flutter/material.dart';
import '../services/json_service.dart';

class SongSearchPage extends StatefulWidget {
  @override
  _SongSearchPageState createState() => _SongSearchPageState();
}

class _SongSearchPageState extends State<SongSearchPage> {
  final JsonService _jsonService = JsonService();
  final TextEditingController _bpmController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _searchSongs() async {
    final bpm = int.tryParse(_bpmController.text) ?? 0;
    final results = await _jsonService.getSongsByBPMRange(
        widget.bpm.toInt() - 10, widget.bpm.toInt() + 10);

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Songs by BPM')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _bpmController,
              decoration: InputDecoration(labelText: 'Enter BPM'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchSongs,
              child: Text('Search'),
            ),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(child: Text('No songs found.'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final song = _searchResults[index];
                        return ListTile(
                          title: Text(song["title"]),
                          subtitle: Text("BPM: ${song["Tempo"]}"),
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
