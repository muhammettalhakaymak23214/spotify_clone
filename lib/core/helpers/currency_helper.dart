import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class CurrencyHelper {
  CurrencyHelper._();
  static String formatPrice(dynamic price, BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final symbol = NumberFormat.simpleCurrency(locale: locale).currencySymbol;
    return "$price $symbol";
  }
  static String getSymbol(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return NumberFormat.simpleCurrency(locale: locale).currencySymbol;
  }
}