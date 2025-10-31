import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:resume_maker/models/resume_model.dart';
import 'package:resume_maker/services/database_helper.dart';
import 'package:resume_maker/Template/classic_template.dart';
import 'package:resume_maker/Template/modern_template.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  final dbHelper = DatabaseHelper.instance;

  Future<Uint8List> createResume(String templateName) async {
    // Fetch all data from the database and map it to model classes.
    final profileRows = await dbHelper.queryAllRows(
      DatabaseHelper.tableProfile,
    );
    final aboutRows = await dbHelper.queryAllRows(DatabaseHelper.tableAbout);

    final educationList = (await dbHelper.queryAllRows(
      DatabaseHelper.tableEducation,
    )).map((row) => Education.fromMap(row)).toList();
    final experienceList = (await dbHelper.queryAllRows(
      DatabaseHelper.tableExperience,
    )).map((row) => Experience.fromMap(row)).toList();
    final skillsList = (await dbHelper.queryAllRows(
      DatabaseHelper.tableSkills,
    )).map((row) => Skill.fromMap(row)).toList();
    final projectsList = (await dbHelper.queryAllRows(
      DatabaseHelper.tableProjects,
    )).map((row) => Project.fromMap(row)).toList();
    final awardsList = (await dbHelper.queryAllRows(
      DatabaseHelper.tableAwards,
    )).map((row) => Award.fromMap(row)).toList();
    final languagesList = (await dbHelper.queryAllRows(
      DatabaseHelper.tableLanguages,
    )).map((row) => Language.fromMap(row)).toList();
    final hobbiesList = (await dbHelper.queryAllRows(
      DatabaseHelper.tableHobbies,
    )).map((row) => Hobby.fromMap(row)).toList();

    // Safely create model instances for single-row tables.
    final profileData = profileRows.isNotEmpty
        ? Profile.fromMap(profileRows.first)
        : null;
    final aboutData = aboutRows.isNotEmpty
        ? About.fromMap(aboutRows.first)
        : null;

    // Route to the correct template generation method.
    if (templateName == 'Classic') {
      final classicTemplate = ClassicTemplate();
      return classicTemplate.create(
        profileData: profileData,
        aboutData: aboutData,
        educationList: educationList,
        experienceList: experienceList,
        skillsList: skillsList,
        awardsList: awardsList,
        projectsList: projectsList,
        languagesList: languagesList,
        hobbiesList: hobbiesList,
      );
    } else if (templateName == 'Modern') {
      final modernTemplate = ModernTemplate();
      return modernTemplate.create(
        profileData: profileData,
        aboutData: aboutData,
        educationList: educationList,
        experienceList: experienceList,
        skillsList: skillsList,
        awardsList: awardsList,
        projectsList: projectsList,
        languagesList: languagesList,
        hobbiesList: hobbiesList,
      );
    } else {
      return _createDefaultResume(
        profileData: profileData,
        aboutData: aboutData,
        educationList: educationList,
        experienceList: experienceList,
        skillsList: skillsList,
        projectsList: projectsList,
        awardsList: awardsList,
        languagesList: languagesList,
        hobbiesList: hobbiesList,
      );
    }
  }

  // ================= DEFAULT TEMPLATE =================
  Future<Uint8List> _createDefaultResume({
    required Profile? profileData,
    required About? aboutData,
    required List<Education> educationList,
    required List<Experience> experienceList,
    required List<Skill> skillsList,
    required List<Project> projectsList,
    required List<Award> awardsList,
    required List<Language> languagesList,
    required List<Hobby> hobbiesList,
  }) async {
    final PdfDocument document = PdfDocument();
    var page = document.pages.add();
    var pageSize = page.getClientSize();
    var graphics = page.graphics;

    graphics.drawRectangle(
      pen: PdfPens.black,
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
    );

    final PdfFont headingFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      24,
      style: PdfFontStyle.bold,
    );
    final PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.helvetica, 14);
    final PdfFont sectionFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      16,
      style: PdfFontStyle.bold,
    );
    final PdfFont bodyFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

    double currentY = 30;
    double leftMargin = 30;
    double contentWidth = pageSize.width - (2 * leftMargin);

    // Helper to check for page breaks and create a new page if needed.
    // It returns the new Y position.
    double checkDefaultPageBreak(double currentY) {
      if (currentY > pageSize.height - 60) {
        // 60px bottom margin
        page = document.pages.add();
        pageSize = page.getClientSize();
        graphics = page.graphics;
        graphics.drawRectangle(
          pen: PdfPens.black,
          bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        );
        return 30.0; // Reset Y to top margin for the new page
      }
      return currentY;
    }

    // Header
    final String name =
        '${profileData?.firstName ?? 'Your'} ${profileData?.lastName ?? 'Name'}'
            .trim();
    graphics.drawString(
      name,
      headingFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(leftMargin, currentY, contentWidth, 30),
    );
    currentY += 35;

    final String contactLine =
        '${profileData?.email ?? ''} | ${profileData?.phone ?? ''}';
    graphics.drawString(
      contactLine,
      subHeadingFont,
      brush: PdfBrushes.darkGray,
      bounds: Rect.fromLTWH(leftMargin, currentY, contentWidth, 20),
    );
    currentY += 40;

    // Summary Section
    currentY = checkDefaultPageBreak(currentY);
    graphics.drawString(
      'Summary',
      sectionFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(leftMargin, currentY, contentWidth, 20),
    );
    currentY += 25;
    currentY = _drawWrappedText(
      graphics: graphics,
      text: aboutData?.aboutText ?? '',
      font: bodyFont,
      x: leftMargin,
      y: currentY,
      maxWidth: contentWidth,
      lineHeight: 15,
    );
    currentY += 20;

    // Experience Section
    currentY = checkDefaultPageBreak(currentY);
    graphics.drawString(
      'Experience',
      sectionFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(leftMargin, currentY, contentWidth, 20),
    );
    currentY += 25;
    for (final exp in experienceList) {
      currentY = checkDefaultPageBreak(currentY);
      graphics.drawString(
        exp.position ?? '',
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(leftMargin, currentY, contentWidth, 15),
      );
      currentY += 18;
      graphics.drawString(
        exp.company ?? '',
        bodyFont,
        bounds: Rect.fromLTWH(leftMargin, currentY, contentWidth, 15),
      );
      currentY += 18;
      currentY = _drawWrappedText(
        graphics: graphics,
        text: exp.description ?? '',
        font: bodyFont,
        x: leftMargin,
        y: currentY,
        maxWidth: contentWidth,
        lineHeight: 15,
      );
      currentY += 15;
    }

    // Projects Section
    if (projectsList.isNotEmpty) {
      currentY = checkDefaultPageBreak(currentY);
      currentY += 20;
      graphics.drawString(
        'Projects',
        sectionFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(leftMargin, currentY, contentWidth, 20),
      );
      currentY += 25;
      for (final project in projectsList) {
        currentY = checkDefaultPageBreak(currentY);
        graphics.drawString(
          project.name ?? '',
          PdfStandardFont(
            PdfFontFamily.helvetica,
            12,
            style: PdfFontStyle.bold,
          ),
          bounds: Rect.fromLTWH(leftMargin, currentY, contentWidth, 15),
        );
        currentY += 18;
        currentY = _drawWrappedText(
          graphics: graphics,
          text: project.description ?? '',
          font: bodyFont,
          x: leftMargin,
          y: currentY,
          maxWidth: contentWidth,
          lineHeight: 15,
        );
        currentY += 15;
      }
    }

    final List<int> bytes = await document.save();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  // Helper function to draw wrapped text
  double _drawWrappedText({
    required PdfGraphics graphics,
    required String text,
    required PdfFont font,
    required double x,
    required double y,
    required double maxWidth,
    required double lineHeight,
    PdfTextAlignment alignment = PdfTextAlignment.left,
  }) {
    if (text.isEmpty) return y;

    final words = text.split(' ');
    String currentLine = '';
    double currentY = y;

    for (int i = 0; i < words.length; i++) {
      final testLine = currentLine.isEmpty
          ? words[i]
          : '$currentLine ${words[i]}';
      final testWidth = font.measureString(testLine).width;

      if (testWidth > maxWidth && currentLine.isNotEmpty) {
        graphics.drawString(
          currentLine,
          font,
          bounds: Rect.fromLTWH(x, currentY, maxWidth, lineHeight),
          format: PdfStringFormat(alignment: alignment),
          brush: PdfBrushes.black,
        );
        currentY += lineHeight;
        currentLine = words[i];
      } else {
        currentLine = testLine;
      }
    }

    if (currentLine.isNotEmpty) {
      graphics.drawString(
        currentLine,
        font,
        bounds: Rect.fromLTWH(x, currentY, maxWidth, lineHeight),
        format: PdfStringFormat(alignment: alignment),
        brush: PdfBrushes.black,
      );
      currentY += lineHeight;
    }

    return currentY;
  }
}
