import 'package:flutter/material.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';

class GridCard extends StatelessWidget {
  final String title;
  final int value;
  final String image;

  const GridCard({
    super.key,
    required this.title,
    required this.value,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: AppColors.grey,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              AppSizes.cardRadiusLg,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.defaultSpace,
          horizontal: 10.0,
        ).copyWith(bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // icon
            Image(
              height: 65.0,
              image: AssetImage(image),
            ),

            // title
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            // value
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
