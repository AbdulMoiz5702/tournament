import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tournemnt/consts/colors.dart';


class CustomSlider extends StatelessWidget {
  CustomSlider({required this.child,required this.deleteOnPressed,required this.editOnPressed,this.key,this.isHomeScreen = false,this.isTeamScreen = false,this.editOnPressedTeamScreen,this.labelEdit = 'Edit',this.labelDelete = 'Delete',this.labelDisqualify = 'Disqualify'});
  final void Function(BuildContext)  ? editOnPressed;
  final void Function(BuildContext)  ? editOnPressedTeamScreen;
  final void Function(BuildContext)  deleteOnPressed;
  final Widget child ;
  final bool isHomeScreen;
  final Key ? key;
  final bool isTeamScreen ;
  final String labelEdit ;
  final String labelDelete;
  final String labelDisqualify;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      key:Key(key.toString()),
      child: Slidable(
          key: Key(key.toString()),
          endActionPane: ActionPane(
            motion:const StretchMotion(),
            children: [
              // settings option
              isHomeScreen == true ?  Container(height: 1,width: 1,): SlidableAction(
                foregroundColor: isTeamScreen == false ? whiteColor : greenColor,
                  flex: isTeamScreen == false ? 1 : 5,
                  onPressed: editOnPressed,
                  backgroundColor: isTeamScreen == false ?sliderEditColor : qualifyColorSlider,
                  label: labelEdit,
                  icon: isTeamScreen == false ? Icons.edit : Icons.check_circle_outline_outlined,
                borderRadius:const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              isTeamScreen == false ?  Container(height: 1,width: 1,): SlidableAction(
                autoClose:true,
                flex: isTeamScreen == false ? 1 : 5,
                label:labelDisqualify,
                onPressed: editOnPressedTeamScreen,
                backgroundColor:disqualifyColorSlider,
                icon: isTeamScreen == false ? Icons.edit : Icons.unpublished_outlined,
                foregroundColor: redColor,
              ),
              // delete option
              isHomeScreen == true ?  Container(height: 1,width: 1,): SlidableAction(
                autoClose:true,
                flex: isTeamScreen == false ? 1 : 5,
                label:labelDelete,
                onPressed: deleteOnPressed,
                backgroundColor:isTeamScreen == false? sliderDeleteColor : deleteColorSlider,
                icon: Icons.delete,
                borderRadius:const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ],
          ),
          child: child ),
    );
  }
}
