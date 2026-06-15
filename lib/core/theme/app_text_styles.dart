import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle pageTitle = TextStyle(
    color: AppColors.ink,
    fontSize: 34,
    height: 40 / 34,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle metricNumber = TextStyle(
    color: AppColors.ink,
    fontSize: 64,
    height: 1,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle label = TextStyle(
    color: AppColors.muted,
    fontSize: 13,
    height: 19 / 13,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bodyStrong = TextStyle(
    color: AppColors.ink,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w700,
  );
}
