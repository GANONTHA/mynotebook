import 'package:flutter/material.dart';
import 'package:mynotebook/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog ( 
  BuildContext context
) {
  return showGenericDialog(
    context: context, 
    title: 'Delete', 
    content: 'Are you sure you want to Delete ?', 
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    }
    ).then((value) => value?? false,
    );
}