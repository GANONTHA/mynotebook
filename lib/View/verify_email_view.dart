import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';

class VerifyEmailview extends StatefulWidget {
  const VerifyEmailview({super.key});

  @override
  State<VerifyEmailview> createState() => _VerifyEmailviewState();
}

class _VerifyEmailviewState extends State<VerifyEmailview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your Email'),
        centerTitle: true,
      ),
      body: Column(children: [
        const Text(
            "We've sent you an email verification please verify your account"),
        const Text(
            "If you haven't received email verification yet, press the button below"),
        TextButton(
          onPressed: () {
            context
                .read<AuthBloc>()
                .add(const AuthEventSendEmailVerification());
          },
          child: const Text('Send email Verification'),
        ),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(const AuthEventLogOut());
          },
          child: const Text('Restart'),
        )
      ]),
    );
  }
}
