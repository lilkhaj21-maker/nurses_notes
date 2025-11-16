import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../services/local_storage.dart';

class NCPPage extends StatefulWidget {
  const NCPPage({super.key});

  @override
  State<NCPPage> createState() => _NCPPageState();
}

class _NCPPageState extends State<NCPPage> {
  List<Map<String, String>> ncps = [];
  final nameController = TextEditingController();
  final sectionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNCPs();
  }

  Future<void> _loadNCPs() async {
    final loaded = await LocalStorage.loadList('ncp_list');
    setState(() {
      ncps = loaded.map((e) => Map<String, String>.from(e)).toList();
    });
  }

  Future<void> _saveNCPs() async {
    await LocalStorage.saveList('ncp_list', ncps);
  }

  void _addNCP() {
    final formKey = GlobalKey<FormState>();
    final Map<String, String> newNCP = {
      "assessmentSubjective": "",
      "assessmentObjective": "",
      "diagnosis": "",
      "planning": "",
      "intervention": "",
      "rationale": "",
      "evaluation": "",
      "studentName": "",
      "section": "",
      "date": "",
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Nursing Care Plan"),
        content: SizedBox(
          width: 500,
          height: 520,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Student Name",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newNCP["studentName"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Section",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newNCP["section"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Date",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newNCP["date"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Subjective",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (v) => newNCP["assessmentSubjective"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Objective",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (v) => newNCP["assessmentObjective"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Diagnosis",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newNCP["diagnosis"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Planning",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (v) => newNCP["planning"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Intervention",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (v) => newNCP["intervention"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Rationale",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (v) => newNCP["rationale"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Evaluation",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (v) => newNCP["evaluation"] = v,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() => ncps.add(newNCP));
              await _saveNCPs();
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

  Future<void> _exportSingleNCP(int index) async {
    final ncp = ncps[index];
    final pdf = pw.Document();

    final tnr = pw.Font.times();

    final folioLandscape = PdfPageFormat(13 * PdfPageFormat.inch, 8.5 * PdfPageFormat.inch,
        marginAll: 20).landscape;

    pdf.addPage(
      pw.Page(
        pageFormat: folioLandscape,
        build: (context) => pw.DefaultTextStyle(
          style: pw.TextStyle(font: tnr, fontSize: 12),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("NURSING CARE PLAN",
                  style: pw.TextStyle(font: tnr, fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Student Name: ${ncp['studentName']}"),
              pw.Text("Section: ${ncp['section']}"),
              pw.Text("Date: ${ncp['date']}"),
              pw.SizedBox(height: 15),
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(width: 0.5),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                headers: [
                  "Assessment",
                  "Diagnosis",
                  "Planning",
                  "Intervention",
                  "Rationale",
                  "Evaluation"
                ],
                data: [
                  [
                    "Subjective:\n${ncp['assessmentSubjective']}\n\nObjective:\n${ncp['assessmentObjective']}",
                    ncp["diagnosis"] ?? "",
                    ncp["planning"] ?? "",
                    ncp["intervention"] ?? "",
                    ncp["rationale"] ?? "",
                    ncp["evaluation"] ?? "",
                  ]
                ],
                cellAlignments: {
                  0: pw.Alignment.topLeft,
                  1: pw.Alignment.topLeft,
                  2: pw.Alignment.topLeft,
                  3: pw.Alignment.topLeft,
                  4: pw.Alignment.topLeft,
                  5: pw.Alignment.topLeft,
                },
              ),
            ],
          ),
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'NCP_${ncp['studentName'] ?? 'Entry'}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nursing Care Plans")),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNCP,
        child: const Icon(Icons.add),
      ),
      body: ncps.isEmpty
          ? const Center(child: Text("No Nursing Care Plans yet. Tap + to add."))
          : ListView.builder(
              itemCount: ncps.length,
              itemBuilder: (context, index) {
                final ncp = ncps[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Diagnosis: ${ncp['diagnosis']}"),
                        Text("Evaluation: ${ncp['evaluation']}"),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.download),
                            label: const Text("Download PDF"),
                            onPressed: () => _exportSingleNCP(index),
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