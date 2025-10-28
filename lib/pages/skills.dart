import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:resume_maker/widgets/app_text_field.dart';
import 'package:resume_maker/services/database_helper.dart';

class Skills extends StatefulWidget {
  final VoidCallback? onNext;
  const Skills({super.key, this.onNext});

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController skillNameController = TextEditingController();
  final List<Map<String, dynamic>> skills = [];
  String selectedProficiency = 'Intermediate';
  final dbHelper = DatabaseHelper.instance;

  final List<String> proficiencyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  void _loadSkills() async {
    final allRows = await dbHelper.queryAllRows(DatabaseHelper.tableSkills);
    setState(() {
      skills.clear();
      skills.addAll(allRows);
    });
  }

  void _addSkill() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newSkillName = skillNameController.text.trim();
      final isDuplicate = skills.any(
          (skill) => skill['name'].toString().toLowerCase() == newSkillName.toLowerCase());

      if (isDuplicate) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This skill has already been added.')),
          );
        }
        return;
      }

      Map<String, dynamic> row = {
        'name': newSkillName,
        'proficiency': selectedProficiency,
      };
      final id = await dbHelper.insert(DatabaseHelper.tableSkills, row);
      row['id'] = id;
      setState(() {
        skills.add(row);
        skillNameController.clear();
        selectedProficiency = 'Intermediate';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Skill added successfully!')),
        );
      }
    }
  }

  void _deleteSkill(int id, int index) async {
    await dbHelper.delete(DatabaseHelper.tableSkills, id);
    setState(() {
      skills.removeAt(index);
    });
  }

  @override
  void dispose() {
    skillNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 85),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Skills',
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
                  'List your skills and specify the area in which you have expertise.',
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    label: 'Skill',
                                    controller: skillNameController,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Please enter a skill';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 140,
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
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                  255,
                                                  152,
                                                  146,
                                                  244,
                                                ),
                                                Color(0xffe4d8fd),
                                                Color(0xff9b8fff),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                        ),
                                        hint: Text(
                                          'Level',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                        value: selectedProficiency,
                                        items: proficiencyLevels.map((m) {
                                          return DropdownMenuItem<String>(
                                            value: m,
                                            child: Text(
                                              m,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            setState(
                                              () => selectedProficiency = val,
                                            );
                                          }
                                        },
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (skills.isNotEmpty) ...[
                              Text(
                                'Added Skills',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...skills.asMap().entries.map((entry) {
                                final index = entry.key;
                                final skill = entry.value;
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
                                              skill['name'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              skill['proficiency'],
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
                                          _deleteSkill(skill['id'], index);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),

                              const SizedBox(height: 24),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                        onTap: _addSkill,
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
    );
  }
}
