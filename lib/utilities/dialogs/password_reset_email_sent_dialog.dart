import 'package:flutter/widgets.dart';
import 'package:mynotebook/utilities/dialogs/generic_dialog.dart';

Future<void> showPassWordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password reset',
    content:
        'We have sent you a password reset email, please click on the link',
    optionBuilder: () => {
      'Ok': null,
    },
  );
}
