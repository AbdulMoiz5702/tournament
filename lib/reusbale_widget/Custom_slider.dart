import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tournemnt/consts/colors.dart';


class CustomSlider extends StatelessWidget {
  CustomSlider({required this.child,required this.deleteOnPressed,required this.editOnPressed,this.key,this.isHomeScreen = false,this.isTeamScreen = false,this.editOnPressedTeamScreen});
  final void Function(BuildContext)  ? editOnPressed;
  final void Function(BuildContext)  ? editOnPressedTeamScreen;
  final void Function(BuildContext)  deleteOnPressed;
  final Widget child ;
  final bool isHomeScreen;
  final Key ? key;
  final bool isTeamScreen ;



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
                  onPressed: editOnPressed,
                  backgroundColor: statusContainer3,
                  icon: isTeamScreen == false ? Icons.edit : Icons.check_circle_outline_outlined,
                borderRadius:const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              isTeamScreen == false ?  Container(height: 1,width: 1,): SlidableAction(
                autoClose:true,
                onPressed: editOnPressedTeamScreen,
                backgroundColor: redColor,
                icon: isTeamScreen == false ? Icons.edit : Icons.unpublished_outlined,
              ),
              // delete option
              isHomeScreen == true ?  Container(height: 1,width: 1,): SlidableAction(
                autoClose:true,
                onPressed: deleteOnPressed,
                backgroundColor: deleteColor,
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
