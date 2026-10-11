import 'package:flutter/material.dart';

/// Design tokens extracted directly from DESIGN.md (inspired by Mastercard design language).
abstract final class AppTokens {
  // ---------------------------------------------------------------------------
  // Colors (DESIGN.md Section 2)
  // ---------------------------------------------------------------------------

  /// Canvas Cream: Default body canvas, muted putty tone (#F3F0EE).
  static const Color canvasCream = Color(0xFFF3F0EE);

  /// Lifted Cream: One step lighter than canvas for raised nested sections (#FCFBFA).
  static const Color liftedCream = Color(0xFFFCFBFA);

  /// White: Reserved for floating nav, modals, pill buttons, satellites (#FFFFFF).
  static const Color white = Color(0xFFFFFFFF);

  /// Soft Bone: Cool-gray alternative surface (#F4F4F4).
  static const Color softBone = Color(0xFFF4F4F4);

  /// Ink Black: Warm near-black for primary CTAs, text, footer (#141413).
  static const Color inkBlack = Color(0xFF141413);

  /// Charcoal: Slightly softer black for text alternates (#262627).
  static const Color charcoal = Color(0xFF262627);

  /// Slate Gray: Muted secondary text, eyebrows, disabled states (#696969).
  static const Color slateGray = Color(0xFF696969);

  /// Granite: Deeper gray for inline accents (#555555).
  static const Color granite = Color(0xFF555555);

  /// Graphite: Deeper gray for link alternates (#565656).
  static const Color graphite = Color(0xFF565656);

  /// Dust Taupe: Very muted cream-gray for whisper text or placeholders (#D1CDC7).
  static const Color dustTaupe = Color(0xFFD1CDC7);

  /// Signal Orange: Burnt/rust CTA orange for consent & alert actions (#CF4500).
  static const Color signalOrange = Color(0xFFCF4500);

  /// Orbit Orange: alias của signalOrange cho vòng quỹ đạo & điểm nhấn.
  static const Color orbitOrange = signalOrange;

  /// Light Signal Orange: Carroty orange for decorative orbital arcs & indicators (#F37338).
  static const Color lightSignalOrange = Color(0xFFF37338);

  /// Clay Brown: Deep rust for secondary link-style actions (#9A3A0A).
  static const Color clayBrown = Color(0xFF9A3A0A);

  /// Link Blue: Dusty blue for links and info callouts (#3860BE).
  static const Color linkBlue = Color(0xFF3860BE);

  /// Mastercard Red: Brand logo only (#EB001B).
  static const Color brandRed = Color(0xFFEB001B);

  /// Mastercard Yellow: Brand logo only (#F79E1B).
  static const Color brandYellow = Color(0xFFF79E1B);

  // ---------------------------------------------------------------------------
  // Semantic Color Additions (Outside DESIGN.md)
  // ---------------------------------------------------------------------------

  /// Green for positive income transactions (#1B8755).
  static const Color semanticIncome = Color(
    0xFF1B8755,
  ); // bổ sung, không có trong DESIGN.md

  /// Soft warning for budget usage at or above 80% (#D97706).
  static const Color semanticBudgetWarning = Color(
    0xFFD97706,
  ); // bổ sung, không có trong DESIGN.md

  /// Exceeded danger for budget usage above 100% (#C53030).
  static const Color semanticBudgetExceeded = Color(
    0xFFC53030,
  ); // bổ sung, không có trong DESIGN.md

  // ---------------------------------------------------------------------------
  // Typography (DESIGN.md Section 3)
  // ---------------------------------------------------------------------------

  static const String fontFamilyPrimary = 'MarkForMC';
  static const List<String> fontFamilyFallbacks = <String>[
    'Sofia Sans',
    'Arial',
    'sans-serif',
  ];

  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightBodySignature =
      FontWeight.w400; // 450 signature weight fallback
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightBold = FontWeight.w700;

  // ---------------------------------------------------------------------------
  // Spacing (DESIGN.md Section 5 - Base 8px)
  // ---------------------------------------------------------------------------

  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;
  static const double space96 = 96.0;
  static const double space128 = 128.0;

  // ---------------------------------------------------------------------------
  // Border Radius (DESIGN.md Section 5)
  // ---------------------------------------------------------------------------

  static const double radiusMicro = 4.0;
  static const double radiusSmall = 6.0;
  static const double radiusButton = 20.0;
  static const double radiusConsentButton = 24.0;
  static const double radiusStadium = 40.0;
  static const double radiusPill = 999.0;

  // ---------------------------------------------------------------------------
  // Elevation & Shadows (DESIGN.md Section 6)
  // ---------------------------------------------------------------------------

  static const double elevationFlat = 0.0;

  static const List<BoxShadow> shadowLevel1 = <BoxShadow>[
    BoxShadow(
      color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
      blurRadius: 24.0,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowLevel2 = <BoxShadow>[
    BoxShadow(
      color: Color(0x14000000), // rgba(0, 0, 0, 0.08)
      blurRadius: 48.0,
      offset: Offset(0, 24),
    ),
  ];
}
