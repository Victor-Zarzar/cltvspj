import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PTBR {
  PTBR._();

  static Widget asset() {
    return SvgPicture.asset('assets/icons/pt.svg', height: 20, width: 20);
  }
}

class ES {
  ES._();

  static Widget asset() {
    return SvgPicture.asset('assets/icons/es.svg', height: 20, width: 20);
  }
}

class EN {
  EN._();

  static Widget asset() {
    return SvgPicture.asset('assets/icons/en.svg', height: 20, width: 20);
  }
}
