import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../services/local_storage.dart';

class ReflectionPage extends StatefulWidget {
  const ReflectionPage({super.key});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  List<Map<String, String>> reflections = [];

  @override
  void initState() {
    super.initState();
    _loadReflections();
  }

  Future<void> _loadReflections() async {
    final loaded = await LocalStorage.loadList('reflections');
    setState(() {
      reflections = loaded.map((e) => Map<String, String>.from(e)).toList();
    });
  }

  Future<void> _saveReflections() async {
    await LocalStorage.saveList('reflections', reflections);
  }

  void _addReflection() {
    final Map<String, String> newReflection = {
      "studentName": "",
      "section": "",
      "date": "",
      "title": "",
      "content": "",
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Reflection"),
        content: SizedBox(
          width: 500,
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Student Name",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => newReflection["studentName"] = v,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Section",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => newReflection["section"] = v,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Date",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => newReflection["date"] = v,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => newReflection["title"] = v,
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 15,
                  decoration: const InputDecoration(
                    labelText: "Your Reflection",
                    alignLabelWithHint: true,
                    hintText: "Write your reflection here...",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => newReflection["content"] = v,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                reflections.add(newReflection);
              });
              await _saveReflections();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSingleReflection(int index) async {
    final reflection = reflections[index];
    final pdf = pw.Document();

    final tnr = pw.Font.times();

    final folioPortrait = PdfPageFormat(13 * PdfPageFormat.inch, 8.5 * PdfPageFormat.inch,
        marginAll: 20).portrait;

    pdf.addPage(
      pw.Page(
        pageFormat: folioPortrait,
        build: (context) => pw.DefaultTextStyle(
          style: pw.TextStyle(font: tnr, fontSize: 12),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Name: ${reflection['studentName'] ?? ''}"),
              pw.Text("Section: ${reflection['section'] ?? ''}"),
              pw.Text("Date: ${reflection['date'] ?? ''}"),
              pw.SizedBox(height: 15),
              pw.Center(
                child: pw.Text(
                  reflection['title'] ?? 'Untitled Reflection',
                  style: pw.TextStyle(
                    font: tnr,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                reflection['content'] ?? '',
                style: pw.TextStyle(font: tnr, fontSize: 12, height: 1.5),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Reflection_${reflection['studentName'] ?? 'Entry'}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reflections")),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReflection,
        child: const Icon(Icons.add),
      ),
      body: reflections.isEmpty
          ? const Center(
              child: Text(
                "No reflections yet. Tap + to add one.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: reflections.length,
              itemBuilder: (context, index) {
                final reflection = reflections[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reflection['title'] ?? 'Untitled Reflection',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          reflection['content'] ?? '',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, height: 1.4),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.download),
                            label: const Text("Download PDF"),
                            onPressed: () => _exportSingleReflection(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}