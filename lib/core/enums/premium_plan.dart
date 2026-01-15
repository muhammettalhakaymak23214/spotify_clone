import 'package:flutter/material.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';


enum PremiumPlan {
  individual(price: "44.99"),
  student(price: "19.99"),
  duo(price: "134.99"),
  family(price: "164.99");

  final String price;
  const PremiumPlan({required this.price});
}

extension PremiumPlanExtension on PremiumPlan {
  String getTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      PremiumPlan.individual => l10n.planIndividualTitle,
      PremiumPlan.student => l10n.planStudentTitle,
      PremiumPlan.duo => l10n.planDuoTitle,
      PremiumPlan.family => l10n.planFamilyTitle,
    };
  }

  String getSubtitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      PremiumPlan.individual => l10n.planIndividualSubtitle,
      PremiumPlan.student => l10n.planStudentSubtitle,
      PremiumPlan.duo => l10n.planDuoSubtitle,
      PremiumPlan.family => l10n.planFamilySubtitle,
    };
  }
}