import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import '../consts/colors.dart';
import '../consts/images_path.dart';
import '../controllers/Add_tournamnets_contoller.dart';
import '../reusbale_widget/customLeading.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';


class TournamentTypeSelection extends StatelessWidget {
  const TournamentTypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AddTournamentsController());
    return BgWidget(
        child: Scaffold(
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
                          title: 'Add Tournament',
                          context: context,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                        Sized(height: 0.005),
                        smallText(
                          title: 'Enter Your Valid Information .',
                          color: secondaryTextColor.withOpacity(0.85),
                          fontWeight: FontWeight.w500,
                        ),
                        Sized(height: 0.005),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Expanded(child: Container(color: whiteColor,child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Sized(height: 0.02,),
                  const  SelectionType(title: 'Over Type',imagePath: match,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(3, (index) {
                      return Obx(() => GestureDetector(
                        onTap: (){
                        controller.selectRadioOver(index);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Sized(width: 0.03,),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 20),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                border: Border.all(color: controller.currentIndexOver.value ==index ? qualifyColorSlider : radioButtonColor ),
                                shape: BoxShape.circle,
                                color: transparentColor,
                              ),
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.currentIndexOver.value ==index ? qualifyColorSlider : radioButtonColor ,
                                ),
                              ),
                            ),
                            Sized(width: 0.05,),
                            smallText(title: overTypeList[index],color:blackColor,fontSize: 14)
                          ],
                        ),
                      ));
                    }),
                  ),
                  Sized(height: 0.03,),
                  const  SelectionType(title: 'Age Level',imagePath: ageLevel,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(3, (index) {
                      return Obx(() => GestureDetector(
                        onTap: (){
                           controller.selectRadioAge(index);

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Sized(width: 0.03,),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 20),
                              height: 20,
                              width: 20,
                              decoration:  BoxDecoration(
                                border: Border.all(color: controller.currentIndexAge.value ==index ? qualifyColorSlider : radioButtonColor ),
                                color: transparentColor,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.currentIndexAge.value == index ? qualifyColorSlider : radioButtonColor ,
                                ),
                              ),
                            ),
                            Sized(width: 0.05,),
                            smallText(title: ageLevelList[index],color:blackColor,fontSize: 14)
                          ],
                        ),
                      ));
                    }),
                  ),
                  Sized(height: 0.03,),
                  const  SelectionType(title: 'Area Level',imagePath: areaLevel,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(3, (index) {
                      return Obx(() => GestureDetector(
                        onTap: (){
                          controller.selectRadioArea(index);

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Sized(width: 0.03,),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 20),
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: radioButtonColor,
                              ),
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.currentIndexArea.value == index ? qualifyColorSlider : radioButtonColor ,
                                ),
                              ),
                            ),
                            Sized(width: 0.05,),
                            smallText(title: areaLevelList[index],color:blackColor,fontSize: 14)
                          ],
                        ),
                      ));
                    }),
                  ),
                  Sized(height: 0.03,),
                  Obx(
                    ()=> controller.currentIndexArea.value == 2 ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      largeText(title: 'Area Level',fontSize: 24,fontWeight: FontWeight.w500,color: cardTextColor),
                      Sized(height: 0.02,),
                      CustomTextField(
                          isMaxLines: true,
                          imagePath: addressIcon,
                          controller: controller.areaLevel, hintText:'Enter address', validate: (value){
                        return value.isEmpty ? 'Enter address': null;
                      }),
                      Sized(height: 0.02,),
                    ],
                  ): Sized(height: 0.02,),
                 ),
                  CustomButton(title: 'Confirm', onTap: (){
                    controller.tournamentType.text = controller.getSelectedTournamentType();
                    Navigator.pop(context, controller.tournamentType.text);
                  }),
                  Sized(height: 0.1,),
                ],
              ),
            ),
          ),)),
        ));
  }
}

class SelectionType extends StatelessWidget {
  final String title;
  final String imagePath;
  const SelectionType({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:7,horizontal: 10),
      decoration: BoxDecoration(
        color: tCardBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SvgPicture.asset(imagePath,color: whiteColor,height:25,),
          Sized(width: 0.1,),
          largeText(
            title:title,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: whiteColor,
          ),
        ],
      ),
    );
  }
}