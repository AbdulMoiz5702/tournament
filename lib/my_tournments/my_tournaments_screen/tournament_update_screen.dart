import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late String name;
  late String organizerName;
  late String organizerPhoneNumber;
  late String tournamentFee;
  late String tournamentOvers;
  late String location;
  late String startDate;

  @override
  void initState() {
    super.initState();
    name = widget.tournament.name;
    organizerName = widget.tournament.organizerName;
    organizerPhoneNumber = widget.tournament.organizerPhoneNumber;
    tournamentFee = widget.tournament.tournamentFee;
    tournamentOvers = widget.tournament.tournamentOvers;
    location = widget.tournament.location;
    startDate = widget.tournament.tournmentStartDate;
  }

  void _updateTournament() async {
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      _formKey.currentState!.save();
      await FirebaseFirestore.instance
          .collection('Tournaments')
          .doc(widget.tournament.id)
          .update({
        'name': name,
        'organizerName': organizerName,
        'organizerPhoneNumber': organizerPhoneNumber,
        'tournamentFee': tournamentFee,
        'tournamentOvers': tournamentOvers,
        'location': location,
        'startDate': startDate,
      }).then((value){
        isLoading = false;
        setState(() {});
        Navigator.pop(context);
      }).onError((error, stackTrace){
        isLoading = false;
        setState(() {});
        throw ToastClass.showToastClass(context: context, message: 'Something went wrong');
      });

    }
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
          key: _formKey,
          child: ListView(
            cacheExtent: 0,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue: name,
                labelText: 'Name',
                onSaved: (value) => name = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue: organizerName,
                labelText: 'Organizer Name',
                onSaved: (value) => organizerName = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the organizer name' : null,
              ),
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue: organizerPhoneNumber,
                labelText: 'Organizer Phone Number',
                onSaved: (value) => organizerPhoneNumber = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the organizer phone number' : null,
              ),
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue: tournamentFee,
                labelText: 'Tournament Fee',
                onSaved: (value) => tournamentFee = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the tournament fee' : null,
              ),
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue: tournamentOvers,
                labelText: 'Tournament Overs',
                onSaved: (value) => tournamentOvers = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the tournament overs' : null,
              ),
              Sized(height: 0.02,),
              CustomTextFormField(
                initialValue: location,
                labelText: 'Location',
                onSaved: (value) => location = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the location' : null,
              ),
              Sized(height: 0.02,),
              CustomDateFormField(
                initialValue: startDate,
                labelText: 'Start Date',
                onSaved: (value) => startDate = value!,
                validator: (value) => value!.isEmpty ? 'Please enter the start date' : null,
              ),
          SizedBox(height:MediaQuery.sizeOf(context).height * 0.03),
          isLoading == true ? Center(child: const CircularProgressIndicator()) :CustomButton(title: 'Update', onTap: _updateTournament),
            ],
          ),
        ),
      ),
    );
  }
}

