import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../services/local_storage.dart';

class DrugStudyPage extends StatefulWidget {
  const DrugStudyPage({super.key});

  @override
  State<DrugStudyPage> createState() => _DrugStudyPageState();
}

class _DrugStudyPageState extends State<DrugStudyPage> {
  List<Map<String, String>> drugStudies = [];

  @override
  void initState() {
    super.initState();
    _loadDrugStudies();
  }

  Future<void> _loadDrugStudies() async {
    final loaded = await LocalStorage.loadList('drug_studies');
    setState(() {
      drugStudies = loaded.map((e) => Map<String, String>.from(e)).toList();
    });
  }

  Future<void> _saveDrugStudies() async {
    await LocalStorage.saveList('drug_studies', drugStudies);
  }

  void _addDrugStudy() {
    final formKey = GlobalKey<FormState>();
    final Map<String, String> newDrug = {
      "studentName": "",
      "section": "",
      "date": "",
      "drugName": "",
      "genericName": "",
      "classification": "",
      "mechanism": "",
      "indication": "",
      "contraindication": "",
      "adverseReaction": "",
      "nursingBefore": "",
      "nursingDuring": "",
      "nursingAfter": "",
      "source": "",
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Drug Study"),
        content: SizedBox(
          width: 500,
          height: 550,
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
                    onChanged: (v) => newDrug["studentName"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Section",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newDrug["section"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Date",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newDrug["date"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Drug Name",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newDrug["drugName"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Generic Name",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newDrug["genericName"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Classification",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newDrug["classification"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Mechanism of Action",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (v) => newDrug["mechanism"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Indication",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newDrug["indication"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Contraindication",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newDrug["contraindication"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Adverse Reaction",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (v) => newDrug["adverseReaction"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nursing Responsibility (Before)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (v) => newDrug["nursingBefore"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nursing Responsibility (During)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (v) => newDrug["nursingDuring"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nursing Responsibility (After)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (v) => newDrug["nursingAfter"] = v,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Source",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => newDrug["source"] = v,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() => drugStudies.add(newDrug));
              await _saveDrugStudies();
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

  Future<void> _exportSingleDrug(int index) async {
    final drug = drugStudies[index];
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
              pw.Text("DRUG STUDY FORMAT",
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Student Name: ${drug['studentName']}"),
              pw.Text("Section: ${drug['section']}"),
              pw.Text("Date: ${drug['date']}"),
              pw.SizedBox(height: 15),
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(width: 0.5),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                headers: [
                  "Drug Name / Generic Name",
                  "Classification",
                  "Mechanism of Action",
                  "Indication",
                  "Contraindication",
                  "Adverse Reaction",
                  "Nursing Responsibilities"
                ],
                data: [
                  [
                    "${drug['drugName']}\n(${drug['genericName']})",
                    drug["classification"] ?? "",
                    drug["mechanism"] ?? "",
                    drug["indication"] ?? "",
                    drug["contraindication"] ?? "",
                    drug["adverseReaction"] ?? "",
                    "Before: ${drug['nursingBefore']}\n\nDuring: ${drug['nursingDuring']}\n\nAfter: ${drug['nursingAfter']}",
                  ]
                ],
                cellAlignments: {
                  0: pw.Alignment.topLeft,
                  1: pw.Alignment.topLeft,
                  2: pw.Alignment.topLeft,
                  3: pw.Alignment.topLeft,
                  4: pw.Alignment.topLeft,
                  5: pw.Alignment.topLeft,
                  6: pw.Alignment.topLeft,
                },
              ),
              pw.SizedBox(height: 15),
              pw.Text("Source: ${drug['source']}"),
            ],
          ),
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'DrugStudy_${drug['studentName'] ?? 'Entry'}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drug Studies")),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDrugStudy,
        child: const Icon(Icons.add),
      ),
      body: drugStudies.isEmpty
          ? const Center(child: Text("No Drug Studies yet. Tap + to add."))
          : ListView.builder(
              itemCount: drugStudies.length,
              itemBuilder: (context, index) {
                final drug = drugStudies[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${drug['drugName']} (${drug['genericName']})",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("Classification: ${drug['classification']}"),
                        Text("Indication: ${drug['indication']}"),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.download),
                            label: const Text("Download PDF"),
                            onPressed: () => _exportSingleDrug(index),
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