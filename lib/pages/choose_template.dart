import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseTemplate extends StatefulWidget {
  const ChooseTemplate({super.key});

  @override
  State<ChooseTemplate> createState() => _ChooseTemplateState();
}

class Resumetemplate {
  final String name;
  final String thumbnail;

  Resumetemplate(this.name, this.thumbnail);
}

class _ChooseTemplateState extends State<ChooseTemplate> {
  final List<Resumetemplate> Templates = [
    Resumetemplate('Modern', 'images/template1.avif'),
    Resumetemplate('classic', 'images/template3.jpg'),
    Resumetemplate('professional', 'images/template4.jpeg'),
    Resumetemplate('Normal', 'images/template2.jpg'),
  ];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff5f56ee), Color(0xffe4d8fd), Color(0xff9b8fff)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.07),
            child: Column(
              children: [
                Text(
                  'Choose Templetes',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Container(
                  width: screenWidth * 0.33,
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xffffb300),
                        Color.fromARGB(255, 255, 255, 255),
                        Color(0xffffb300),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04
                    ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.8
                          ),
                      itemCount: Templates.length,
                      itemBuilder: (BuildContext context, int index) {
                        final template = Templates[index];
                        return InkWell(
                          onTap: () {

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              //horizontal: screenWidth * 0.10,
                              vertical: screenHeight * 0.01,
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
                                  offset: Offset(0, 12),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      template.thumbnail,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  template.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
