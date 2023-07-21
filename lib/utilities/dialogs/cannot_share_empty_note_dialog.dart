import 'package:flutter/material.dart';
import 'package:mynotebook/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'can not share an empty note',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
