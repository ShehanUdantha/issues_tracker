import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';

class SearchBarStyle {
  var searchBarDecoration = InputDecoration(
    prefixIcon: const Icon(
      Iconsax.search_normal,
      color: AppColors.buttonDisabled,
    ),
    hintText: 'Search Issues',
    hintStyle: const TextStyle(
      color: AppColors.buttonDisabled,
    ),
    fillColor: Colors.transparent,
    contentPadding: const EdgeInsets.all(
      AppSizes.spaceBtwItems,
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(
        AppSizes.cardRadiusLg,
      ),
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.grey,
      ),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.grey,
      ),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
      borderSide: const BorderSide(width: 1, color: Color(0xFF8D8C8C)),
    ),
  );
}
