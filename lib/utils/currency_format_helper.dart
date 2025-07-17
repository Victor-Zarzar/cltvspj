import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

final currencyFormat = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: '',
  decimalDigits: 2,
);

MoneyMaskedTextController moneyMaskedController({String symbol = 'R\$ '}) {
  return MoneyMaskedTextController(
    leftSymbol: symbol,
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
}

void formatCurrency(MoneyMaskedTextController controller) {
  final value = controller.numberValue;
  controller.updateValue(value);
}
