import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:resume_maker/pages/aboutme.dart';
import 'package:resume_maker/pages/award_page.dart';
import 'package:resume_maker/pages/declaration_page.dart';
import 'package:resume_maker/pages/education.dart';
import 'package:resume_maker/pages/experiance.dart';
import 'package:resume_maker/pages/hobbie.dart';
import 'package:resume_maker/pages/language.dart';
import 'package:resume_maker/pages/profile_pages.dart';
import 'package:resume_maker/pages/projects.dart';
import 'package:resume_maker/pages/references.dart';
import 'package:resume_maker/pages/signature.dart';
import 'package:resume_maker/pages/skills.dart';

class TabItem {
  final IconData icon;
  final String label;
  const TabItem({required this.icon, required this.label});
}

class CreateResume extends StatefulWidget {
  const CreateResume({super.key});

  @override
  State<CreateResume> createState() => _CreateResumeState();
}

class _CreateResumeState extends State<CreateResume> {
  int currentStep = 0;
  final PageController pageController = PageController();

  final List<TabItem> tabs = const [
    TabItem(icon: Icons.account_box_rounded, label: 'Profile'),
    TabItem(icon: Icons.emoji_events_outlined, label: 'Awards'),
    TabItem(icon: Icons.assignment_outlined, label: 'Declaration'),
    TabItem(icon: Icons.info_outline, label: 'About me'),
    TabItem(icon: Icons.school_outlined, label: 'Education'),
    TabItem(icon: Icons.emoji_emotions_outlined, label: 'Hobbies'),
    TabItem(icon: Icons.language_outlined, label: 'Languages'),
    TabItem(icon: Icons.checklist_outlined, label: 'Projects'),
    TabItem(icon: Icons.book_outlined, label: 'References'),
    TabItem(icon: Icons.work_outline, label: 'Experience'),
    TabItem(icon: Icons.code_outlined, label: 'Skills'),
    TabItem(icon: Icons.edit, label: 'Signature'),
  ];
  final ScrollController tabScrollController = ScrollController();
  final List<GlobalKey> tabKeys = List.generate(12, (index) => GlobalKey());

  void animateToTab(int i) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final context = tabKeys[i].currentContext;
      if (context == null) return;

      final RenderBox currentTabBox = context.findRenderObject() as RenderBox;
      final Size tabSize = currentTabBox.size;
      final Offset tabPosition = currentTabBox.localToGlobal(
        Offset.zero,
        ancestor: this.context.findRenderObject(),
      );

      final double tabCenter = tabPosition.dx + tabSize.width / 2;
      final double screenWidth = MediaQuery.of(this.context).size.width;
      final double desiredOffset = tabCenter - screenWidth / 2;

      tabScrollController.animateTo(
        desiredOffset + tabScrollController.offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void dispose() {
    tabScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff5f56ee), Color(0xffe4d8fd), Color(0xff9b8fff)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'BUILD RESUME',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 150,
              height: 5,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xffffb300),
                    Color.fromARGB(255, 255, 255, 255),
                    Color(0xffffb300),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              controller: tabScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (i) {
                  final selected = currentStep == i;
                  Widget tabInnerContent = Row(
                    children: [
                      Icon(
                        tabs[i].icon,
                        color: selected ? Colors.white : Colors.white70,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tabs[i].label,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  );
                  Widget tabContent = Container(
                    margin: EdgeInsets.only(left: i == 0 ? 12 : 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: tabInnerContent,
                  );
                  if (selected) {
                    tabContent = ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          margin: EdgeInsets.only(left: i == 0 ? 12 : 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
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
                          child: tabInnerContent,
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    key: tabKeys[i],
                    onTap: () {
                      setState(() => currentStep = i);
                      animateToTab(i);
                      if (currentStep == 1) {
                        pageController.jumpToPage(i);
                      } else {
                        pageController.animateToPage(
                          i,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: tabContent,
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() => currentStep = index);
                  animateToTab(index);
                },
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return profilepage(
                        onNext: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    case 1:
                      return awardpage(
                        onNext: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    case 2:
                      return Declaration(
                        onNext: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    case 3:
                      return Aboutme(
                        onNext: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    case 4:
                      return Education(
                        onNext: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    case 5:
                      return Hobbies(
                        onNext: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    case 6:
                      return Languages(
                        onNext: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    case 7:
                      return Projects(
                        onNext: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    case 8:
                      return References(
                        onNext: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    case 9:
                      return Experience(
                        onNext: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    case 10:
                      return Skills(
                        onNext: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    case 11:
                      return SignaturePage();
                    default:
                      return Center(child: Text('Page not found'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
