import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:resume_maker/models/resume_model.dart';
import 'package:resume_maker/services/database_helper.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  final dbHelper = DatabaseHelper.instance;

  Future<Uint8List> createResume(String templateName) async {
    // Fetch all data from the database and map it to model classes.
    final profileRows = await dbHelper.queryAllRows(
      DatabaseHelper.tableProfile,
    );
    final aboutRows = await dbHelper.queryAllRows(DatabaseHelper.tableAbout);
    final declarationRows = await dbHelper.queryAllRows(
      DatabaseHelper.tableDeclaration,
    );
    final signatureRows = await dbHelper.queryAllRows(
      DatabaseHelper.tableSignature,
    );

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
    final signatureData = signatureRows.isNotEmpty
        ? Signature.fromMap(signatureRows.first)
        : null;

    // Route to the correct template generation method.
    if (templateName == 'Classic') {
      return _createClassicResume(
        profileData: profileData,
        aboutData: aboutData,
        educationList: educationList,
        experienceList: experienceList,
        skillsList: skillsList,
        awardsList: awardsList,
        signatureData: signatureData,
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
        signatureData: signatureData,
      );
    }
  }

  // ================= CLASSIC TEMPLATE =================
  Future<Uint8List> _createClassicResume({
    required Profile? profileData,
    required About? aboutData,
    required List<Education> educationList,
    required List<Experience> experienceList,
    required List<Skill> skillsList,
    required List<Award> awardsList,
    required Signature? signatureData,
    required List<Project> projectsList,
    required List<Language> languagesList,
    required List<Hobby> hobbiesList,
  }) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    final PdfGraphics graphics = page.graphics;

    graphics.drawRectangle(
      pen: PdfPens.black,
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
    );

    final goldColor = PdfColor(230, 201, 129);
    final sidebarBgColor = PdfColor(247, 247, 247);

    final nameFont = PdfStandardFont(PdfFontFamily.timesRoman, 25);
    final titleFont = PdfStandardFont(PdfFontFamily.timesRoman, 18);
    final sectionTitleFont = PdfStandardFont(
      PdfFontFamily.timesRoman,
      13,
      style: PdfFontStyle.bold,
    );
    final jobTitleFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      12,
      style: PdfFontStyle.bold,
    );
    final bodyFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final sidebarTextFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final bulletFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

    final String fullName =
        '${profileData?.firstName ?? ''} ${profileData?.lastName ?? ''}'
            .trim()
            .toUpperCase();
    final String jobTitle = profileData?.jobTitle ?? 'Substitute Teacher';

    // =================== HEADER SECTION (UPDATED) ===================
    double headerY = 50;

    // --- Measurements ---
    final double nameTextWidth = nameFont.measureString(fullName).width;
    final double boxHeight = 45;

    // CHANGED: Make the golden box wider for the overflow effect.
    final double boxWidth = nameTextWidth + 100;
    final double boxX = (pageSize.width - boxWidth) / 2;

    final double titleStripHeight = 50;
    // Position the title strip so the golden box can overlap its top part.
    final double titleStripY = headerY + (boxHeight / 1.25);

    // --- Drawing Order for Overflow Effect ---

    // 1. Draw the grey background bar first.
    graphics.drawRectangle(
      brush: PdfSolidBrush(sidebarBgColor),
      bounds: Rect.fromLTWH(0, titleStripY, pageSize.width, titleStripHeight),
    );

    // 2. Draw the golden border box on top of the grey bar.
    graphics.drawRectangle(
      pen: PdfPen(goldColor, width: 2),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(boxX, headerY, boxWidth, boxHeight),
    );

    // 3. Draw the text last, so it appears on top of everything.
    graphics.drawString(
      fullName,
      nameFont,
      bounds: Rect.fromLTWH(0, headerY, pageSize.width, boxHeight),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
      brush: PdfBrushes.black,
    );

    graphics.drawString(
      jobTitle,
      titleFont,
      bounds: Rect.fromLTWH(0, titleStripY, pageSize.width, titleStripHeight),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
      brush: PdfBrushes.black,
    );

    // Set the starting point for the rest of the content.
    double contentStartY = titleStripY + titleStripHeight + 25;
    // ================= END OF HEADER SECTION =================

    final double sidebarWidth = 120;
    final double sidebarX = 30;
    final double mainContentX = sidebarX + sidebarWidth + 25;
    final double mainContentWidth = pageSize.width - mainContentX - 30;

    graphics.drawLine(
      PdfPen(goldColor, width: 1.5),
      Offset(sidebarX + sidebarWidth + 12, contentStartY - 10),
      Offset(sidebarX + sidebarWidth + 12, pageSize.height - 30),
    );

    // ... (The rest of your code remains unchanged) ...
    double sidebarY = contentStartY;

    graphics.drawString(
      'CONTACT',
      sectionTitleFont,
      bounds: Rect.fromLTWH(sidebarX, sidebarY, sidebarWidth, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
      brush: PdfBrushes.black,
    );
    sidebarY += 22;

    final contactLines = [
      profileData?.email ?? 'default.email@example.com',
      profileData?.phone ?? '(123) 456-7890',
      profileData?.address ?? '123 Main St',
      '${profileData?.city ?? 'City'} ${profileData?.country ?? 'Country'}',
      profileData?.pincode ?? '000000',
      profileData?.linkedin, 
      profileData?.github, 
    ];

    for (final line in contactLines) {
      if (line != null && line.isNotEmpty) {
        sidebarY = _drawWrappedText(
          graphics: graphics,
          text: line,
          font: sidebarTextFont,
          x: sidebarX,
          y: sidebarY,
          maxWidth: sidebarWidth,
          lineHeight: 14,
          alignment: PdfTextAlignment.left,
        );
      }
    }

    sidebarY += 20;
    graphics.drawString(
      'EDUCATION',
      sectionTitleFont,
      bounds: Rect.fromLTWH(sidebarX, sidebarY, sidebarWidth, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
      brush: PdfBrushes.black,
    );
    sidebarY += 22;

    if (educationList.isNotEmpty) {
      final edu = educationList.first;
      sidebarY = _drawWrappedText(
        graphics: graphics,
        text: edu.degree ?? 'Degree',
        font: sidebarTextFont,
        x: sidebarX,
        y: sidebarY,
        maxWidth: sidebarWidth,
        lineHeight: 14,
        alignment: PdfTextAlignment.left,
      );
      // graphics.drawString(
      //   edu.field ?? 'Field of Study',
      //   sidebarTextFont,
      //   bounds: Rect.fromLTWH(sidebarX, sidebarY, sidebarWidth, 14),
      //   format: PdfStringFormat(alignment: PdfTextAlignment.left),
      //   brush: PdfBrushes.black,
      // );
      //sidebarY += 14;
      sidebarY = _drawWrappedText(
        graphics: graphics,
        text: edu.school ?? 'University',
        font: sidebarTextFont,
        x: sidebarX,
        y: sidebarY,
        maxWidth: sidebarWidth,
        lineHeight: 14,
        alignment: PdfTextAlignment.left,
      );
      graphics.drawString(
        '${edu.fromYear ?? 'YYYY'} - ${edu.toYear ?? 'YYYY'}',
        sidebarTextFont,
        bounds: Rect.fromLTWH(sidebarX, sidebarY, sidebarWidth, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        brush: PdfBrushes.black,
      );
      sidebarY += 14;
      sidebarY = _drawWrappedText(
        graphics: graphics,
        text: '${edu.place ?? 'City'}, ${edu.country ?? 'Country'}',
        font: sidebarTextFont,
        x: sidebarX,
        y: sidebarY,
        maxWidth: sidebarWidth,
        lineHeight: 14,
        alignment: PdfTextAlignment.left,
      );
    }

    sidebarY += 20;
    graphics.drawString(
      'SKILLS',
      sectionTitleFont,
      bounds: Rect.fromLTWH(sidebarX, sidebarY, sidebarWidth, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
      brush: PdfBrushes.black,
    );
    sidebarY += 22;

    // Define column widths for the two-column skill layout
    final double skillNameWidth = sidebarWidth * 0.6;
    final double proficiencyX = sidebarX + skillNameWidth;
    final double proficiencyWidth = sidebarWidth - skillNameWidth;

    for (final skill in skillsList) {
      // Draw skill name in the left part of the column
      graphics.drawString(
        skill.name,
        sidebarTextFont,
        bounds: Rect.fromLTWH(sidebarX, sidebarY, skillNameWidth, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        brush: PdfBrushes.black,
      );
      // Draw proficiency in the right part of the column
      graphics.drawString(
        skill.proficiency,
        sidebarTextFont,
        bounds: Rect.fromLTWH(proficiencyX, sidebarY, proficiencyWidth, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        brush: PdfBrushes.darkGray,
      );
      sidebarY += 14; // Move to the next line
    }

    sidebarY += 20;
    graphics.drawString(
      'CERTIFICATIONS',
      sectionTitleFont,
      bounds: Rect.fromLTWH(sidebarX, sidebarY, sidebarWidth, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
      brush: PdfBrushes.black,
    );
    sidebarY += 22;

    if (awardsList.isNotEmpty) {
      for (final cert in awardsList) {
        sidebarY = _drawWrappedTextClassic(
          graphics: graphics,
          text: cert.title ?? '',
          font: sidebarTextFont,
          x: sidebarX,
          y: sidebarY,
          maxWidth: sidebarWidth,
          lineHeight: 13,
          alignment: PdfTextAlignment.left,
        );
        sidebarY = _drawWrappedTextClassic(
          graphics: graphics,
          text: cert.issuer ?? '',
          font: sidebarTextFont,
          x: sidebarX,
          y: sidebarY,
          maxWidth: sidebarWidth,
          lineHeight: 13,
          alignment: PdfTextAlignment.left,
        );
        sidebarY = _drawWrappedTextClassic(
          graphics: graphics,
          text: '${cert.year ?? 'YYYY'} - ${cert.month ?? 'MM'}',
          font: sidebarTextFont,
          x: sidebarX,
          y: sidebarY,
          maxWidth: sidebarWidth,
          lineHeight: 13,
          alignment: PdfTextAlignment.left,
        );
        sidebarY = _drawWrappedTextClassic(
          graphics: graphics,
          text: cert.description ?? '',
          font: sidebarTextFont,
          x: sidebarX,
          y: sidebarY,
          maxWidth: sidebarWidth,
          lineHeight: 13,
          alignment: PdfTextAlignment.left,
        );
        sidebarY += 15;     
      }
    } else {
      sidebarY = _drawWrappedTextClassic(
        graphics: graphics,
        text: 'No Certifications Listed',
        font: sidebarTextFont,
        x: sidebarX,
        y: sidebarY,
        maxWidth: sidebarWidth,
        lineHeight: 13,
        alignment: PdfTextAlignment.left,
      );
    }

    sidebarY += 20;
    double mainY = contentStartY;
    graphics.drawString(
      'CAREER OBJECTIVE',
      sectionTitleFont,
      bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 20),
      brush: PdfBrushes.black,
    );
    mainY += 22;

    final objective =
        aboutData?.aboutText ?? 'A summary of your career objective...';
    mainY = _drawWrappedTextClassic(
      graphics: graphics,
      text: objective,
      font: bodyFont,
      x: mainContentX,
      y: mainY,
      maxWidth: mainContentWidth,
      lineHeight: 13,
    );
    mainY += 15;
    graphics.drawString(
      'PROJECTS',
      sectionTitleFont,
      bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 20),
    );
    mainY += 22;
    for (final project in projectsList) {
      graphics.drawString(
        project.name ?? 'Project Name',
        jobTitleFont,
        bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 16),
        brush: PdfBrushes.black,
      );
      mainY += 16;
      graphics.drawString(
        project.role ?? 'Role',
        bodyFont,
        bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 14), 
        brush: PdfBrushes.black,
      );
      mainY += 14;
      graphics.drawString(
        project.description ?? 'Project Description',
        bodyFont,
        bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 14),
        brush: PdfBrushes.black,
      );
      mainY += 14;
      graphics.drawString(
        'Technologies: ${project.technologies ?? 'N/A'}',
        bodyFont,
        bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 14),
        brush: PdfBrushes.darkGray,
      );
      mainY += 14;
      graphics.drawString(
        'Link: ${project.link ?? 'N/A'}',
        bodyFont,
        bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 14),
        brush: PdfBrushes.darkGray,
      );
      mainY += 14;
      graphics.drawString(
        'Year: ${project.year ?? 'N/A'}',
        bodyFont,
        bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 14),
        brush: PdfBrushes.darkGray,
      );
    }
    mainY += 25;
    graphics.drawString(
      'WORK EXPERIENCE',
      sectionTitleFont,
      bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 20),
      brush: PdfBrushes.black,
    );
    mainY += 22;

    for (final exp in experienceList) {
      graphics.drawString(
        exp.position ?? 'Position',
        jobTitleFont,
        bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 16),
        brush: PdfBrushes.black,
      );
      mainY += 16;
      graphics.drawString(
        exp.company ?? 'Company Name',
        bodyFont,
        bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 14),
        brush: PdfBrushes.black,
      );
      mainY += 14;
      final location = 'City, Country'; // Placeholder
      graphics.drawString(
        '${exp.fromYear ?? 'YYYY'} - ${exp.toYear ?? 'YYYY'}  /  $location',
        bodyFont,
        bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 14),
        brush: PdfBrushes.black,
      );
      mainY += 16;
      mainY = _drawWrappedTextClassic(
        graphics: graphics,
        text: exp.description ?? '',
        font: bodyFont,
        x: mainContentX,
        y: mainY,
        maxWidth: mainContentWidth,
        lineHeight: 13,
      );
      mainY += 15;
    }
    graphics.drawString(
      'LANGUAGES',
      sectionTitleFont,
      bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 20),
      brush: PdfBrushes.black,
    );
    mainY += 22;
    if (languagesList.isNotEmpty) {
      for (final lang in languagesList) {
        String abilities = '';
        if (lang.canRead) abilities += 'Read ';
        if (lang.canWrite) abilities += 'Write';
        if (lang.canSpeak) abilities += 'Speak';

        mainY = _drawWrappedTextClassic(
            graphics: graphics,
            text: '${lang.name} (${abilities.trim()})',
            font: bodyFont,
            x: mainContentX,
            y: mainY,
            maxWidth: mainContentWidth,
            lineHeight: 13);
      }
    }

    final List<int> bytes = await document.save();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  // And the helper function (unchanged)
  double _drawWrappedTextClassic({
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
    // ... implementation remains the same
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
    required Signature? signatureData,
  }) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    final PdfGraphics graphics = page.graphics;

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
    graphics.drawString(
      'Experience',
      sectionFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(leftMargin, currentY, contentWidth, 20),
    );
    currentY += 25;
    for (final exp in experienceList) {
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
