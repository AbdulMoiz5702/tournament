import 'package:flutter/material.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';

import '../consts/colors.dart';
import '../reusbale_widget/customLeading.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

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
              padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Sized(height: 0.005),
                      largeText(
                        title: 'About Us',
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
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          color: whiteColor,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: largeText(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                    title: 'Cricket Place',
                  ),
                ),
                Sized(height: 0.05,),
                mediumText(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                 title:  'Welcome to Cricket Place, the ultimate app for cricket enthusiasts who love to compete and connect! Designed specifically for cricket teams, our app makes organizing and joining tournaments easier than ever. Whether you’re a local team looking for a challenge or a seasoned squad eager to compete, Cricket Place is your go-to platform.',
                ),
                Sized(height: 0.05,),
                mediumText(
                  title: 'Features:',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
                Sized(height: 0.02,),
                mediumText(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                 title:  '- Discover tournaments near you with all the details, including entry fees, participating teams, and schedules.\n'
                      '- Create your own tournaments and invite teams to join.\n'
                      '- Connect with other players through in-app chat and calling features.',

                ),
                Sized(height: 0.05,),
                largeText(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                 title:  'Our Mission:',
                ),
                Sized(height: 0.02,),
                mediumText(
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                  title: 'At Cricket Place, we’re on a mission to enhance the cricket experience by making tournaments more accessible and enjoyable. We aim to bring cricket lovers together, encouraging healthy competition and stronger community bonds.',
                    fontSize: 16.0
                ),
                Sized(height: 0.05,),
                mediumText(
                 title:  'Our Inspiration:',
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                  fontSize: 18.0,
                ),
                Sized(height: 0.02,),
                mediumText(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                 title:  'Cricket isn’t just a game; it’s a passion. We created this app to help players focus on what they love most—playing the sport—while simplifying the logistics of organizing and finding tournaments.',
                ),
                Sized(height: 0.05,),
                mediumText(
                  title: 'Who We Are:',
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                  fontSize: 18.0,
                ),
                Sized(height: 0.02,),
                mediumText(
                  title: 'Cricket Place is developed by Falconbyte Solutions, a team dedicated to crafting innovative digital solutions that empower communities. With a shared love for cricket, we’ve poured our passion into creating an app that elevates the way players engage with the game.',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                Sized(height: 0.05,),
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                Sized(height: 0.02,),
                mediumText(
                 title:  'Contact Us:',
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                  fontSize: 18.0,
                ),
                Sized(height: 0.02,),
                mediumText(
                 title:  'Have questions, feedback, or need support? We’d love to hear from you!',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                Sized(height: 0.02,),
                Row(
                  children: [
                    const  Icon(Icons.email, color: blackColor),
                    Sized(width: 0.02,),
                    mediumText(
                      title:'abdulmoizkhan5702@gmail.com',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                  ],
                ),
                Sized(height: 0.02,),
                Row(
                  children: [
                    const  Icon(Icons.email, color: blackColor),
                    Sized(width: 0.02,),
                    mediumText(
                      title:'ishaqfarid280@gmail.com',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                  ],
                ),
                Sized(height: 0.02,),
                Row(
                  children: [
                   const  Icon(Icons.phone, color: blackColor),
                    Sized(width: 0.02,),
                    mediumText(
                      title: '+92 344 94 37976',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                  ],
                ),
                Sized(height: 0.02,),
                Row(
                  children: [
                    const  Icon(Icons.phone, color: blackColor),
                    Sized(width: 0.02,),
                    mediumText(
                      title: '+92 312 304 0474',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                  ],
                ),
                Sized(height: 0.1,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
