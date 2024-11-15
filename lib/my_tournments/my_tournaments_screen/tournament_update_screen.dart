import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
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
    controller.name.value = widget.tournament.name;
    controller.organizerName.value = widget.tournament.organizerName;
    controller.organizerPhoneNumber.value = widget.tournament.organizerPhoneNumber;
    controller.tournamentFee.value = widget.tournament.tournamentFee;
    controller.tournamentOvers.value = widget.tournament.tournamentOvers;
    controller.location.value = widget.tournament.location;
    controller.startDate.value = widget.tournament.tournmentStartDate;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomLeading(),
        centerTitle: true,
        title: mediumText(title: 'Update Tournament',context: context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: controller.formKey,
          child: ListView(
            cacheExtent: 0,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue: controller.name.value,
                labelText: 'Name',
                onSaved: (value) => controller.name.value = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue: controller.organizerName.value,
                labelText: 'Organizer Name',
                onSaved: (value) => controller.organizerName.value = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the organizer name' : null,
              ),
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue:  controller.organizerPhoneNumber.value,
                labelText: 'Organizer Phone Number',
                onSaved: (value) =>  controller.organizerPhoneNumber.value = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the organizer phone number' : null,
              ),
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue: controller.tournamentFee.value,
                labelText: 'Tournament Fee',
                onSaved: (value) => controller.tournamentFee.value = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the tournament fee' : null,
              ),
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue: controller.tournamentOvers.value,
                labelText: 'Tournament Overs',
                onSaved: (value) => controller.tournamentOvers.value = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the tournament overs' : null,
              ),
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue: controller.location.value,
                labelText: 'Location',
                onSaved: (value) => controller.location.value = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the location' : null,
              ),
              Sized(height: 0.02,),
              CustomDateFormField(
                initialValue: controller.startDate.value,
                labelText: 'Start Date',
                onSaved: (value) => controller.startDate.value = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the start date' : null,
              ),
          SizedBox(height:MediaQuery.sizeOf(context).height * 0.03),
          Obx(() => controller.isLoading.value == true ? const Center(child:  CustomIndicator()) :CustomButton(title: 'Update', onTap: (){
            controller.updateTournament(tournamentId: widget.tournament.id, context: context);
          }),)
            ],
          ),
        ),
      ),
    );
  }
}

