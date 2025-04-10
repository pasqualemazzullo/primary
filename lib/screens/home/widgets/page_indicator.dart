import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final ValueNotifier<double> pageNotifier;

  const PageIndicator({
    super.key,
    required this.pageCount,
    required this.pageNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: pageNotifier,
      builder: (context, value, child) {
        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 120,
            child:
                pageCount == 0
                    ? Container(height: 6)
                    : LinearProgressIndicator(
                      value: pageCount == 0 ? 0 : (value + 1) / pageCount,
                      backgroundColor: AppColors.orangeLight,
                      color: AppColors.orange,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(8),
                    ),
          ),
        );
      },
    );
  }
}
