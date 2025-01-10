import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';

import '../consts/colors.dart';
import '../consts/images_path.dart';


class DetailsScreenWidget extends StatelessWidget {
  const DetailsScreenWidget({
    super.key,
    required this.title,
    required this.info,
    this.imagePath = personIcon,
    this.isRulesBox = false,
  });

  final String title;
  final String info;
  final String imagePath;
  final bool isRulesBox;

  @override
  Widget build(BuildContext context) {
    // Split the info into multiple lines if needed
    final List<String> infoLines = info.split('.').where((line) => line.trim().isNotEmpty).toList();

    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: smallText(
              title: title,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Sized(height: 0.005),
          Container(
            height: isRulesBox ? MediaQuery.sizeOf(context).height * 0.2 : null,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            alignment: isRulesBox ? Alignment.topLeft : Alignment.centerLeft,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: detailsBoxBorderColor),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(imagePath),
                Sized(width: 0.02),
                Expanded(
                  child: isRulesBox
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: infoLines
                        .map(
                          (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: smallText(
                          title: '- ${line.trim()}',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    )
                        .toList(),
                  )
                      : smallText(
                    title: info,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

