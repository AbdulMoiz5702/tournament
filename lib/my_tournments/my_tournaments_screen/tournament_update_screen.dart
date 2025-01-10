import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../../consts/colors.dart';
import '../../controllers/Update_Tournament_controller.dart';
import '../../models_classes.dart';
import '../../reusbale_widget/custom_button.dart';
import '../../reusbale_widget/custom_text_form_feild.dart';
import '../../reusbale_widget/date_text_feild.dart'; // Import the new widget

class UpdateTournamentPage extends StatefulWidget {
  final Tournament tournament;

  UpdateTournamentPage({required this.tournament});

  @override
  _UpdateTournamentPageState createState() => _UpdateTournamentPageState();
}

class _UpdateTournamentPageState extends State<UpdateTournamentPage> {

  var controller = Get.put(UpdateTournamentController());



  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.parse(widget.tournament.tournmentStartDate);
    String formattedDate = DateFormat('dd MMM yyyy').format(date);
    controller.name.value = widget.tournament.name;
    controller.organizerName.value = widget.tournament.organizerName;
    controller.organizerPhoneNumber.value = widget.tournament.organizerPhoneNumber;
    controller.tournamentFee.value = widget.tournament.tournamentFee;
    controller.tournamentOvers.value = widget.tournament.tournamentOvers;
    controller.location.value = widget.tournament.location;
    controller.startDate.value = formattedDate;
  }



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
                        title: 'Edit Tournament Info',
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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          color: whiteColor,
          child: Form(
            key: controller.formKey,
            child: ListView(
              physics: BouncingScrollPhysics(),
              cacheExtent: 0,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue: controller.name.value,
                  labelText: 'Name',
                  onSaved: (value) => controller.name.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                ),
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue: controller.organizerName.value,
                  labelText: 'Organizer Name',
                  onSaved: (value) => controller.organizerName.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the organizer name' : null,
                ),
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue:  controller.organizerPhoneNumber.value,
                  labelText: 'Organizer Phone Number',
                  onSaved: (value) =>  controller.organizerPhoneNumber.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the organizer phone number' : null,
                ),
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue: controller.tournamentFee.value,
                  labelText: 'Tournament Fee',
                  onSaved: (value) => controller.tournamentFee.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the tournament fee' : null,
                ),
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue: controller.tournamentOvers.value,
                  labelText: 'Tournament Overs',
                  onSaved: (value) => controller.tournamentOvers.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the tournament overs' : null,
                ),
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue: controller.location.value,
                  labelText: 'Location',
                  onSaved: (value) => controller.location.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the location' : null,
                ),
                Sized(height: 0.03,),
                CustomDateFormField(
                  initialValue: controller.startDate.value,
                  labelText: 'Start Date',
                  onSaved: (value) => controller.startDate.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the start date' : null,
                ),
                Sized(height: 0.03,),
                CustomTimeFormField(
                  initialValue: '5:50 am',
                  labelText: 'Match Time',
                  onSaved: (value) => controller.startDate.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the start date' : null,
                ),
                Sized(height: 0.04,),
            Obx(() => controller.isLoading.value == true ? const Center(child:  CustomIndicator()) :CustomButton(title: 'Update', onTap: (){
              controller.updateTournament(tournamentId: widget.tournament.id, context: context);
            }),),
                Sized(height: 0.04,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

