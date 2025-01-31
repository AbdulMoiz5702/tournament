import 'package:flutter/material.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';

import '../consts/colors.dart';
import '../consts/images_path.dart';
import '../reusbale_widget/customLeading.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';


class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: AppBar(
          leading: CustomLeading(),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 55),
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Sized(height: 0.005),
                      largeText(
                        title: 'Privacy Policy',
                        context: context,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      Sized(height: 0.01),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: whiteColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
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
                Sized(height: 0.05,),
                mediumText(
                  title: 'Welcome to Cricket Place! Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information.',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                Sized(height: 0.05,),
                mediumText(
                  title: '1. Information We Collect',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
                Sized(height: 0.02,),
                mediumText(
                  title:
                  '- Personal Information: When you sign up or use our app, we may collect information such as your name, email address, and phone number.\n'
                      '- Non-Personal Information: We collect app usage data and other non-identifiable details to improve your experience.',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                Sized(height: 0.05,),
                mediumText(
                  title: '2. How We Use the Information',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
                Sized(height: 0.02,),
                mediumText(
                  title:
                  '- To enhance app functionality and provide personalized experiences.\n'
                      '- To communicate with you, including sending updates and notifications.\n'
                      '- To comply with legal obligations and protect against misuse.',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                Sized(height: 0.05,),
                mediumText(
                 title:  '3. Data Sharing',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
                Sized(height: 0.02,),
                mediumText(
                  title :'We do not sell your data. However, we may share it with trusted third parties, such as Firebase and Google APIs, to provide essential app features and analytics.',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                Sized(height: 0.05,),
                mediumText(
                  title: '4. Data Security',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
                Sized(height: 0.02,),
                mediumText(
                 title:  'We use industry-standard security measures to protect your data. However, no system is completely secure, and we cannot guarantee the absolute safety of your information.',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                Sized(height: 0.05,),
                mediumText(
                 title:  '5. User Rights',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
                Sized(height: 0.02,),
                mediumText(
                  title: 'You have the right to access, update, or delete your data. For assistance, please contact us at support@cricketplace.com.',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                Sized(height: 0.05,),
                mediumText(
                 title:  '6. Changes to This Policy',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
                Sized(height: 0.02,),
                mediumText(
                 title:  'We may update this Privacy Policy from time to time. Please check this page for any changes.',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                Sized(height: 0.05,),
                mediumText(
                  title:  '7. Contact Us',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
                Sized(height: 0.02,),
                mediumText(
                  title:  'If you have any questions about this Privacy Policy, feel free to contact us at:\n'
                      'Email: abdulmoizkhan5702@gmail.com / ishaqfarid280@gmail.com\n'
                      'Phone: +92 344 94 37976 / +92 312 304 0474\n',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

