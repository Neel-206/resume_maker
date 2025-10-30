import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfPreviewPage extends StatelessWidget {
  final String path;

  const PdfPreviewPage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final file = XFile(path);
              await Share.shareXFiles([file], text: 'Here is my resume!');
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              try {
                final downloadsDirectory = await getDownloadsDirectory();
                if (downloadsDirectory != null) {
                  final newPath = '${downloadsDirectory.path}/resume.pdf';
                  await File(path).copy(newPath);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Saved to Downloads folder as resume.pdf')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save file: $e')));
              }
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: path,
      ),
    );
  }
}