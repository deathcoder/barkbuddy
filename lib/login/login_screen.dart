import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:barkbuddy/common/assets.dart';
import 'package:barkbuddy/common/logo.dart';
import 'package:barkbuddy/common/widgets/google_signin_button.dart';
import 'package:barkbuddy/common/widgets/vertical_space.dart';
import 'package:barkbuddy/home/home_screen.dart';
import 'package:barkbuddy/login/bloc/login_bloc.dart';
import 'package:barkbuddy/login/services/auth/authentication_service.dart';
import 'package:barkbuddy/login/services/users/barkbuddy_user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginScreen());
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with AfterLayoutMixin<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
            userService: RepositoryProvider.of<BarkbuddyUserService>(context),
            authenticationService:
                RepositoryProvider.of<AuthenticationService>(context))
          ..add(const InitializeLogin()),
        child: const LoginBody(),
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    // todo this is not in context anymore
    //await context.read<NotificationService>().initialize();
  }
}

class LoginBody extends StatelessWidget {
  const LoginBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        switch (state) {
          case LoginState(status: var status)
              when status == LoginStatus.failure:
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Authentication Failure')),
              );
          case LoginState(status: var status)
              when status == LoginStatus.success:
            await Navigator.of(context)
                .pushAndRemoveUntil<void>(HomeScreen.route(), (route) => false);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderSection(),
            DiagonalSection(
              color: Colors.teal.shade700,
              height: 50,
            ),
            const FeatureSection(),
            const DiagonalSection(
              color: Color.fromRGBO(239, 231, 216, 1), // sand
              isTop: true,
              height: 50,
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.teal.shade700,
            child: SafeArea(
              child: Column(
                children: [
                  ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 250
                      ),
                      child: Logo.medium(backgroundColor: null)),
                  GoogleSigninButton(
                    onPressed: () => context.read<LoginBloc>().add(const LoginSubmitted()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FeatureSection extends StatelessWidget {
  const FeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Experience the future of dog sitting!',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          VerticalSpace.small(),
          Text( isWideScreenMode(context) ?
            "Our cutting-edge AI technology listens to your dog's noises in real time, carefully analyzing vocal patterns to detect signs of stress or discomfort. When stress is identified, our system instantly notifies you, allowing you to take timely action."
            : "Our AI technology monitors your dog's behavior, detects stress levels, provides real-time care solutions and instantly notifies you.",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          if(isWideScreenMode(context))
            Text(
              "Along with real-time alerts, we provide tailored care solutions to help keep your dog calm and content, ensuring their well-being is always a priority.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          VerticalSpace.medium(),
          const FeatureIcons(),
        ],
      ),
    );
  }
}

class FeatureIcons extends StatelessWidget {
  const FeatureIcons({super.key});

  @override
  Widget build(BuildContext context) {
    // todo fix heights
    return const Row(
      children: [
        FeatureItem(
          icon: Icons.mic,
          text: 'Advanced bark detection',
          subtext:
              "Accurately identifies and categorizes your dog's barks for tailored responses.",
          height: 200,
        ),
        FeatureItem(
          icon: Icons.show_chart,
          text: 'Real-time stress monitoring',
          subtext:
              "Tracks your dog's stress levels and provides instant insights.",
          height: 200,
        ),
        FeatureItem(
          icon: Icons.notifications_active,
          text: 'Instant owner alerts',
          subtext:
              "Notifies you immediately about your dog's needs and behaviors.",
          height: 200,
        ),
        FeatureItem(
          icon: Icons.psychology,
          text: 'AI-powered care actions',
          subtext:
              "Uses intelligent algorithms to deliver personalized care recommendations.",
          height: 200,
        ),
      ],
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String subtext;
  final double height;

  const FeatureItem(
      {super.key,
      required this.icon,
      required this.text,
      required this.subtext,
      required this.height,
      });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 40, color: Colors.teal.shade700),
                  VerticalSpace.small(),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  if(isWideScreenMode(context))
                    ...[
                      VerticalSpace.small(),
                      Text(
                        subtext,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                ],
              ),
            ),
          ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.topCenter,
            color: const Color(0xFFEFE7D8),
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: Image.asset(Assets.footerIllustration)),
          ),
        ),
      ],
    );
  }
}

class DiagonalSection extends StatelessWidget {
  final Color color;
  final bool isTop;
  final double height;

  const DiagonalSection({
    super.key,
    required this.color,
    required this.height,
    this.isTop = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DiagonalClipper(isTop: isTop),
      child: Container(
        color: color,
        height: height,
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  final bool isTop;

  DiagonalClipper({this.isTop = false});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (isTop) {
      path.moveTo(0.0, 0.0);
      path.lineTo(size.width, size.height * 0.25);
      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
    } else {
      path.moveTo(0.0, 0.0);
      path.lineTo(size.width, 0.0);
      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height * 0.75);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

bool isWideScreenMode(BuildContext context) {
  return MediaQuery.of(context).size.width > 600;
}