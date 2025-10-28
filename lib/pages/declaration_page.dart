import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:resume_maker/widgets/app_text_field.dart';
import 'package:resume_maker/services/database_helper.dart';

class Declaration extends StatefulWidget {
  final VoidCallback? onNext;

  const Declaration({super.key, this.onNext});

  @override
  State<Declaration> createState() => _DeclarationState();
}

class _DeclarationState extends State<Declaration> {
  final TextEditingController declarationController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadDeclarationData();
  }

  void _loadDeclarationData() async {
    final allRows = await dbHelper.queryAllRows(DatabaseHelper.tableDeclaration);
    if (allRows.isNotEmpty) {
      setState(() {
        declarationController.text = allRows.first['declarationText'] ?? '';
      });
    }
  }

  void _saveDeclarationData() async {
    Map<String, dynamic> row = {
      'declarationText': declarationController.text,
    };

    final allRows = await dbHelper.queryAllRows(DatabaseHelper.tableDeclaration);
    if (allRows.isEmpty) {
      await dbHelper.insert(DatabaseHelper.tableDeclaration, row);
    } else {
      row['id'] = allRows.first['id'];
      await dbHelper.update(DatabaseHelper.tableDeclaration, row);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Declaration saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Declaration',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter a verified statement that clearly proclaims your intentions for record-keeping',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 15,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 32,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.40),
                              Colors.white.withOpacity(0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            AppTextField(
                              controller: declarationController,
                              label: 'Declaration',
                              maxLines: 5,
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
          onPressed: () {
            _saveDeclarationData();
            widget.onNext?.call();
          },
          child: Text('Next'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 62),
            backgroundColor: Color.fromARGB(255, 111, 101, 247),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(56),
            ),
            elevation: 8,
            shadowColor: Colors.deepPurpleAccent.withOpacity(0.6),
            textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
