import 'package:flutter/material.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';

import '../consts/colors.dart';
import '../reusbale_widget/customLeading.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';

class LicensesScreen extends StatelessWidget {
  final List<Map<String, String>> licenses = [
    {
      'package': 'firebase_core',
      'license': 'Licensed under the Apache License 2.0.',
    },
    {
      'package': 'firebase_auth',
      'license': 'Licensed under the Apache License 2.0.',
    },
    {
      'package': 'firebase_storage',
      'license': 'Licensed under the Apache License 2.0.',
    },
    {
      'package': 'cloud_firestore',
      'license': 'Licensed under the Apache License 2.0.',
    },
    {
      'package': 'get',
      'license': 'Licensed under the MIT License.',
    },
    {
      'package': 'intl',
      'license': 'Licensed under the Apache License 2.0.',
    },
    {
      'package': 'flutter_slidable',
      'license': 'Licensed under the MIT License.',
    },
    {
      'package': 'image_picker',
      'license': 'Licensed under the Apache License 2.0.',
    },
    {
      'package': 'flutter_sound',
      'license': 'Licensed under the MIT License.',
    },
    {
      'package': 'path_provider',
      'license': 'Licensed under the Apache License 2.0.',
    },
    {
      'package': 'permission_handler',
      'license': 'Licensed under the MIT License.',
    },
    {
      'package': 'voice_message_player',
      'license': 'Licensed under the MIT License.',
    },
    {
      'package': 'zego_uikit_prebuilt_call',
      'license': 'Licensed under the MIT License.',
    },
    {
      'package': 'zego_uikit',
      'license': 'Licensed under the MIT License.',
    },
    {
      'package': 'zego_uikit_signaling_plugin',
      'license': 'Licensed under the MIT License.',
    },
    {
      'package': 'http',
      'license': 'Licensed under the BSD License.',
    },
    {
      'package': 'googleapis_auth',
      'license': 'Licensed under the BSD License.',
    },
    {
      'package': 'cached_network_image',
      'license': 'Licensed under the Apache License 2.0.',
    },
    {
      'package': 'firebase_messaging',
      'license': 'Licensed under the Apache License 2.0.',
    },
    {
      'package': 'flutter_local_notifications',
      'license': 'Licensed under the BSD License.',
    },
    {
      'package': 'flutter_svg',
      'license': 'Licensed under the MIT License.',
    },
    {
      'package': 'google_fonts',
      'license': 'Licensed under the Apache License 2.0.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: LicensePage(
        applicationName: 'Cricket Place',
        applicationVersion: '1.0.7',
        applicationLegalese: '© 2025 Falconbyte Solutions. All rights reserved.',
        applicationIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.2,
            width: MediaQuery.sizeOf(context).width * 0.4,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(image: AssetImage(splashImage),fit: BoxFit.cover,isAntiAlias: true)
            ),
          ),
        ),
      ),
    );
  }
}


