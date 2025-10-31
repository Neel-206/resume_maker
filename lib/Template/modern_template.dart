import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:resume_maker/models/resume_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ModernTemplate {
  Future<Uint8List> create({
    required Profile? profileData,
    required About? aboutData,
    required List<Education> educationList,
    required List<Experience> experienceList,
    required List<Skill> skillsList,
    required List<Award> awardsList,
    required List<Project> projectsList,
    required List<Language> languagesList,
    required List<Hobby> hobbiesList,
  }) async {
    final PdfDocument document = PdfDocument();
    var page = document.pages.add();
    var pageSize = page.getClientSize();
    var graphics = page.graphics;

    // --- Define Colors & Brushes ---
    final sidebarBackgroundColor = PdfColor(252,229,205); // Light tan
    final mainHeaderColor = PdfColor(45, 45, 45); // Dark Gray
    final jobTitleColor = PdfColor(80, 80, 80); // Medium Gray
    final sectionHeaderColor = PdfColor(0, 122, 255); // Blue
    final textColor = PdfColor(33, 33, 33); // Dark text for sidebar
    final sectionTitleFont = PdfStandardFont(
      PdfFontFamily.timesRoman,
      13,
      style: PdfFontStyle.bold,
    );
    // --- Define Fonts ---
    final PdfFont nameFont =
        PdfStandardFont(PdfFontFamily.helvetica, 28, style: PdfFontStyle.bold);
    final PdfFont jobTitleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.italic);
    final PdfFont sidebarSectionFont =
        PdfStandardFont(PdfFontFamily.timesRoman, 14, style: PdfFontStyle.bold);
    final PdfFont sidebarSubHeaderFont =
        PdfStandardFont(PdfFontFamily.timesRoman, 11, style: PdfFontStyle.bold);
    final PdfFont sidebarBodyFont =
        PdfStandardFont(PdfFontFamily.timesRoman, 10);
    final PdfFont mainSectionFont =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    final PdfFont mainBodyFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

    // --- Define Layout ---
    final double sidebarWidth = 180;
    final double mainContentX = sidebarWidth + 30;
    final double mainContentWidth = pageSize.width - mainContentX - 30;
    final double sidebarX = 30;
    double sidebarY = 30;
    double mainY = 30;

    graphics.drawRectangle(
      brush: PdfSolidBrush(sidebarBackgroundColor),
      bounds: Rect.fromLTWH(0, 0, sidebarWidth, pageSize.height),
    );

    void _checkPageBreak(bool isSidebar, double neededSpace) {
      double currentY = isSidebar ? sidebarY : mainY;
      if (currentY + neededSpace > pageSize.height - 30) {
        page = document.pages.add();
        graphics = page.graphics;
        graphics.drawRectangle(
          brush: PdfSolidBrush(sidebarBackgroundColor),
          bounds: Rect.fromLTWH(0, 0, sidebarWidth, pageSize.height),
        );
        sidebarY = 30;
        mainY = 30;
      }
    }

    // --- LEFT SIDEBAR ---
    final double sidebarPadding = 15;
    final double sidebarContentWidth = sidebarWidth - (2 * sidebarPadding);

    graphics.drawLine(
      PdfPens.black,
      Offset(sidebarPadding, sidebarY),
      Offset(sidebarWidth - sidebarPadding, sidebarY),
    );
    sidebarY += 10;

    // -- Education Section --
    _checkPageBreak(true, 50);
    graphics.drawString(
      'EDUCATION',
      sidebarSectionFont,
      brush: PdfSolidBrush(textColor),
      bounds: Rect.fromLTWH(sidebarPadding, sidebarY, sidebarContentWidth, 20),
    );
    sidebarY += 22;

    for (var edu in educationList) {
      _checkPageBreak(true, 60);
      // Degree
      sidebarY = _drawWrappedText(
            graphics: graphics,
            text: edu.degree ?? '',
            font: sidebarSubHeaderFont,
            x: sidebarPadding,
            y: sidebarY,
            maxWidth: sidebarContentWidth,
            lineHeight: 12,
          ) + 2;
      // School
      sidebarY = _drawWrappedText(
            graphics: graphics,
            text: edu.school ?? '',
            font: sidebarBodyFont,
            x: sidebarPadding,
            y: sidebarY,
            maxWidth: sidebarContentWidth,
            lineHeight: 12,
          ) + 2;
      // Date Range
      sidebarY = _drawWrappedText(
            graphics: graphics,
            text: '${edu.fromYear ?? ''} - ${edu.toYear ?? ''}',
            font: sidebarBodyFont,
            x: sidebarPadding,
            y: sidebarY,
            maxWidth: sidebarContentWidth,
            lineHeight: 12,
          ) + 5;
      sidebarY += 15; // Space between education entries
    }

    // --- RIGHT MAIN CONTENT ---
    if (aboutData?.aboutText != null && aboutData!.aboutText!.isNotEmpty) {
      _checkPageBreak(false, 50);
      graphics.drawString('ABOUT ME', mainSectionFont,
          brush: PdfSolidBrush(sectionHeaderColor),
          bounds: Rect.fromLTWH(mainContentX, mainY, mainContentWidth, 20));
      mainY += 25;
      mainY = _drawWrappedText(
            graphics: graphics,
            text: aboutData.aboutText!,
            font: mainBodyFont,
            x: mainContentX,
            y: mainY,
            maxWidth: mainContentWidth,
            alignment: PdfTextAlignment.justify,
            lineHeight: 14,
          ) + 20;
    }

    if (experienceList.isNotEmpty) {
      // ... (Your existing code for Experience, Projects, etc. goes here)
    }

    final List<int> bytes = await document.save();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

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
      final testLine =
          currentLine.isEmpty ? words[i] : '$currentLine ${words[i]}';
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