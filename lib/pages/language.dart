import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:resume_maker/widgets/app_text_field.dart';

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  final TextEditingController languageController = TextEditingController();
  bool canRead = false;
  bool canWrite = false;
  bool canSpeak = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    'Language',
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
                  'Specify languages you understand, articulate, and write clearly and effectively in.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 15,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(36),
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
                          Container(
                            child: Column(
                              children: [
                                AppTextField(label: 'Language', controller: languageController),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            activeColor: Colors.white54,
                                            side: BorderSide(
                                              color: Colors.white54
                                            ),
                                            value: canRead, onChanged: (value) {
                                            setState(() {
                                              canRead = value ?? false;
                                            });
                                          },  
                                          ),
                                          Text('Read',
                                          style: TextStyle(
                                            color: Colors.white54
                                          ),
                                          )
                                        ],
                                      )
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            activeColor: Colors.white54,
                                            side: BorderSide(
                                              color: Colors.white54
                                            ),
                                            value: canWrite, onChanged: (value) {
                                            setState(() {
                                              canWrite = value ?? false;
                                            });
                                          },
                                          ),
                                          Text('Write',
                                          style: TextStyle(
                                            color: Colors.white54
                                          ),
                                          )
                                        ],
                                      )
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            activeColor: Colors.white54,
                                            side: BorderSide(
                                              color: Colors.white54
                                            ),
                                            value: canSpeak, onChanged: (value) {
                                            setState(() {
                                              canSpeak = value ?? false;
                                            });
                                          },
                                          ),
                                          Text('Speak',
                                          style: TextStyle(
                                            color: Colors.white54
                                          ),
                                          )
                                        ],
                                      )
                                    )
                                  ],
                                )
                              ],
                            ),

                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () async {},
                            child: const Text('Next'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 62),
                              backgroundColor: const Color.fromARGB(
                                255,
                                111,
                                101,
                                247,
                              ),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(56),
                              ),
                              elevation: 8,
                              shadowColor: Colors.deepPurpleAccent.withOpacity(
                                0.6,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
    );
  }
}
