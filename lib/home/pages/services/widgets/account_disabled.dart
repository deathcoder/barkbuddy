import 'package:barkbuddy/common/widgets/vertical_space.dart';
import 'package:barkbuddy/home/pages/services/bloc/services_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountDisabled extends StatelessWidget {
  const AccountDisabled({super.key});

  @override
  Widget build(BuildContext context) {
    // todo in widescreen mode the column should align to top left at the start of the page (for all pages)
    // in portrait mode the colum should align top center (?)
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Activation Required',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        VerticalSpace.small(),
        Text(
          'Explore the demo while your account is awaiting activation.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        VerticalSpace.small(),
        ElevatedButton(
          onPressed: () => context.read<ServicesBloc>().add(RequestAccountActivation()),
          child: const Text('Request Activation'),
        ),
      ],
    ));
  }
}
