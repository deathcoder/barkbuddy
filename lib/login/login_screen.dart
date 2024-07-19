import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:barkbuddy/common/widgets/horizontal_space.dart';
import 'package:barkbuddy/home/home_screen.dart';
import 'package:barkbuddy/home/services/notification/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/logo.dart';
import '../common/widgets/material_filled_button.dart';
import '../common/widgets/vertical_space.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginScreen());
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AfterLayoutMixin<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                VerticalSpace.medium(),
                const LoginHeader(),
                VerticalSpace.medium(),
                const LoginBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await context.read<NotificationService>().initialize();
  }
}

class LoginBody extends StatelessWidget {
  const LoginBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
        child: Column(
          children: [
            Text(
              "Experience the Future of Dog Sitting!",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            VerticalSpace.small(),
            Text(
              "BarkBuddy's advanced AI takes care of your furry friend with unmatched reliability and personalized attention. Start now and let our AI sitter provide the ultimate care!",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
              textAlign: TextAlign.center,
            ),
            VerticalSpace.medium(),
            const SecurityBox(),
            VerticalSpace.small(),
            const TermsAndConditions(),
            VerticalSpace.medium(),
            const StartButton(),
          ],
        ),
      ),
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        MaterialFilledButton(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil<void>(HomeScreen.route(), (route) => false),
            height: 60,
            //icon: const Icon(Icons.),
            label: Text(
              "Get Started Now!",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .apply(fontWeightDelta: 10, color: Theme.of(context).colorScheme.onPrimary),
            )),
        if(!kIsWeb) HorizontalSpace.small(),
        if(!kIsWeb)  MaterialFilledButton(
            label: const Text("[debug] get fcm token"),
            height: 60,
            onPressed: () async {
              await context.read<NotificationService>().fcmToken;
            })
      ],
    );
  }
}

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: "By continuing, you agree to our ",
            style: Theme.of(context).textTheme.labelLarge,
            children: [
          TextSpan(
            text: "Privacy Policy",
            style: Theme.of(context).textTheme.labelLarge!.apply(fontWeightDelta: 4),
          ),
          const TextSpan(
            text: " and ",
          ),
          TextSpan(
            text: "T&Cs",
            style: Theme.of(context).textTheme.labelLarge!.apply(fontWeightDelta: 4),
          ),
        ]));
  }
}

class SecurityBox extends StatelessWidget {
  const SecurityBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.onSurface,
      elevation: 4,
      child: InkWell(
        onTap: () => {},
        // TODO this should open some firebase doc maybe
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.safety_check,
                size: 50,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Flexible(
                child: RichText(
                  text: TextSpan(text: "Bark Buddy uses ", style: Theme.of(context).textTheme.labelLarge, children: [
                    TextSpan(
                        text: "Firebase",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .apply(fontWeightDelta: 4, color: Theme.of(context).colorScheme.secondary)),
                    const TextSpan(
                      text: " to ensure security when continuing with Google",
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Logo.medium();
  }
}
