import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:resume_maker/widgets/app_text_field.dart';


class Projects extends StatefulWidget {
  final VoidCallback? onNext;
  const Projects({super.key, this.onNext});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController techController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    descController.dispose();
    techController.dispose();
    linkController.dispose();
    yearController.dispose();
    super.dispose();
  }

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
                    'Projects',
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
                  'Record details of your completed projects to showcase your skills and experience effectively.',
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
                                AppTextField(label: 'Project Title', controller: nameController),
                                const SizedBox(height: 12),
                                AppTextField(label: 'Role', controller: roleController),
                                const SizedBox(height: 12),
                                AppTextField(label: 'Description', controller: descController, maxLines: 4),
                                const SizedBox(height: 12),
                                AppTextField(label: 'Technologies', controller: techController),
                                const SizedBox(height: 12),
                                AppTextField(label: 'Project Link', controller: linkController, keyboardType: TextInputType.url),
                                const SizedBox(height: 12),
                                AppTextField(label: 'Year', controller: yearController, keyboardType: TextInputType.number),
                              ],
                            ),

                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: widget.onNext,
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