import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:resume_maker/widgets/app_text_field.dart';

class Education extends StatefulWidget {
  final VoidCallback? onNext;

  const Education({super.key, this.onNext});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController fieldController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController discriptionController = TextEditingController();
  final TextEditingController marksController = TextEditingController();
  final List<Map<String,dynamic>> Education = [];

   void addEducation() {
    if (schoolController.text.trim().isNotEmpty ||
        fieldController.text.trim().isNotEmpty ||
        degreeController.text.trim().isNotEmpty ||
        placeController.text.trim().isNotEmpty ||
        countryController.text.trim().isNotEmpty||
        fromController.text.trim().isNotEmpty||
        toController.text.trim().isNotEmpty||
        discriptionController.text.trim().isNotEmpty||
        marksController.text.trim().isNotEmpty) {
      setState(() {
        Education.add({
          'School': schoolController.text.trim(),
          'Field': fieldController.text.trim(),
          'Degree': degreeController.text.trim(),
          'Place': placeController.text.trim(),
          'Country':countryController.text.trim(),
          'From':fromController.text.trim(),
          'To':toController.text.trim(),
          'Discription': discriptionController.text.trim(),
          'Marks': marksController.text.trim(),
        });
        schoolController.clear();
        fieldController.clear();
        degreeController.clear();
        placeController.clear();
        countryController.clear();
        fromController.clear();
        toController.clear();
        discriptionController.clear();
        marksController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 85),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Education',
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
                    'Fill in your educational achievements and institution names in the designated area.',
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
                              label: 'School/Collage Name',
                              controller: schoolController,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    label: 'Field of Study',
                                    controller: fieldController,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppTextField(
                                    label: 'Degree',
                                    controller: degreeController,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    label: 'Place',
                                    controller: placeController,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppTextField(
                                    label: 'Country',
                                    controller: countryController,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    label: 'From Year',
                                    controller: fromController,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppTextField(
                                    label: 'To Year',
                                    controller: toController,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            AppTextField(
                              label: 'Description',
                              controller: countryController,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 12),
                            AppTextField(
                              label: 'Marks(%)',
                              controller: marksController,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 12),
                            if (Education.isNotEmpty) ...[
                              Text(
                                'Added Education',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ...Education.asMap().entries.map((entry) {
                                final index = entry.key;
                                final Edu = entry.value;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Edu['School'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Edu['Field'],
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Edu['Degree'],
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Edu['Place'],
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Edu['Country'],
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Edu['From'],
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Edu['To'],
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Edu['Discription'],
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Edu['Marks'],
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white70,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            Education.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          
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
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.onNext != null) {
                    widget.onNext!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 62),
                  backgroundColor: const Color.fromARGB(255, 111, 101, 247),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(56),
                  ),
                  elevation: 8,
                  shadowColor: Colors.deepPurpleAccent.withOpacity(0.6),
                  textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                child: const Text('Next'),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(56),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(56),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(56),
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.60),
                        width: 0.5,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.1),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: addEducation,
                        splashFactory: InkRipple.splashFactory,
                        splashColor: Colors.white.withOpacity(0.2),
                        highlightColor: Colors.white.withOpacity(0.1),
                        child: Center(
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(1),
                                  Colors.white.withOpacity(0.8),
                                ],
                              ).createShader(bounds);
                            },
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
