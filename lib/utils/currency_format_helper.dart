import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

final currencyFormat = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: 'R\$ ',
  decimalDigits: 2,
);

MoneyMaskedTextController moneyMaskedController({String symbol = 'R\$ '}) {
  return MoneyMaskedTextController(
    leftSymbol: symbol,
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
}

String formatNumber(double value) {
  return currencyFormat.format(value);
}
