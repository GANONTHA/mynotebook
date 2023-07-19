import 'package:flutter/material.dart';
import 'package:mynotebook/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog( 
  BuildContext context,
  String text,
){ 
  return showGenericDialog<void>(
    context: context, 
    title: 'An error occurred', 
    content: text, 
    optionBuilder: () => {
      'OK': null,
    }
    );
}