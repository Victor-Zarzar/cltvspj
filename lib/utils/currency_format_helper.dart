import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';

final currencyFormat = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: 'R\$ ',
  decimalDigits: 2,
);

final brlInputFormatter = CurrencyTextInputFormatter.currency(
  locale: 'pt_BR',
  symbol: 'R\$ ',
  decimalDigits: 2,
);

String formatCurrency(double value) => currencyFormat.format(value);

double parseBrlToDouble(String text) {
  final cleaned = text
      .replaceAll('R\$', '')
      .replaceAll(' ', '')
      .replaceAll('.', '')
      .replaceAll(',', '.')
      .trim();

  if (cleaned.isEmpty) return 0.0;
  return double.tryParse(cleaned) ?? 0.0;
}

bool isZeroOrEmptyCurrency(String text) {
  final normalized = text.replaceAll(RegExp(r'[^0-9]'), '');
  if (normalized.isEmpty) return true;

  final valueInCents = int.tryParse(normalized) ?? 0;
  return valueInCents == 0;
}
