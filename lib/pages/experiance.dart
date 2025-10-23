import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:resume_maker/widgets/app_text_field.dart';

class Experience extends StatefulWidget {
  const Experience({super.key});

  @override
  State<Experience> createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  final TextEditingController companyController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController endYearController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedMonth;
  String? endSelectedMonth;

  final List<String> month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void dispose() {
    companyController.dispose();
    positionController.dispose();
    yearController.dispose();
    endYearController.dispose();
    descriptionController.dispose();
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
                    'Experiance',
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
                  'provide your Experienced of your corporate life',
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
                          AppTextField(
                            label: "Company Name",
                            controller: companyController,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: "Position/Role",
                            controller: positionController,
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      label: "From Year",
                                      controller: yearController,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(14),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color.fromARGB(255, 152, 146, 244),
                                                  Color(0xffe4d8fd),
                                                  Color(0xff9b8fff),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                          ),
                                          hint: Text(
                                            'Select Month',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                            ),
                                          ),
                                          value: selectedMonth,
                                          items: month.map((m) {
                                            return DropdownMenuItem<String>(
                                              value: m,
                                              child: Text(
                                                m,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (val) =>
                                              setState(() => selectedMonth = val),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      label: " To Year",
                                      controller: endYearController,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(14),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color.fromARGB(255, 152, 146, 244),
                                                  Color(0xffe4d8fd),
                                                  Color(0xff9b8fff),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                          ),
                                          hint: Text(
                                            'Select Month',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                            ),
                                          ),
                                          value: endSelectedMonth,
                                          items: month.map((m) {
                                            return DropdownMenuItem<String>(
                                              value: m,
                                              child: Text(
                                                m,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (val) =>
                                              setState(() => endSelectedMonth = val),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: "Description",
                            controller: descriptionController,
                            maxLines: 3,
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () async {},
                            child: Text('Next'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 62),
                              backgroundColor: Color.fromARGB(
                                255,
                                111,
                                101,
                                247,
                              ),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
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
                              textStyle: TextStyle(
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
