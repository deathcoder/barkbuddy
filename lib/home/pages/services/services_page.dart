import 'dart:io' show Platform;

import 'package:barkbuddy/common/assets.dart';
import 'package:barkbuddy/common/widgets/vertical_space.dart';
import 'package:barkbuddy/home/pages/services/bloc/services_bloc.dart';
import 'package:barkbuddy/home/pages/services/models/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  get kIsAndroidOrIos => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesBloc, AbstractServicesState>(
      builder: (context, state) {
        var registeredServices = switch (state) {
          ServicesState(userServices: var userServices) => userServices,
        }
            .toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Your Services',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              VerticalSpace.small(),
              const Text(
                'Ai Service Registration',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              VerticalSpace.small(),
              ElevatedButton(
                onPressed: () => _showRegisterTtsDialog(context),
                child: const Text('Register Google Text to Speech Service'),
              ),
              VerticalSpace.small(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.userServices.length,
                itemBuilder: (context, index) {
                  final service = registeredServices[index];
                  return Card(
                    child: ListTile(
                      leading: switch (service) {
                        GeminiUserService() => Image.asset(
                            Assets.geminiIcon,
                            height: IconTheme.of(context).size,
                            width: IconTheme.of(context).size,
                          ),
                        GoogleTextToSpeechUserService() => const Icon(
                            Icons.spatial_audio_off_rounded,
                            color: Colors.grey,
                          ),
                      },
                      title: Text(switch (service) {
                        GeminiUserService() => 'Gemini Service',
                        GoogleTextToSpeechUserService() =>
                          'Google Text To Speech Service'
                      }),
                      subtitle: switch (service) {
                        GeminiUserService(apiKey: var apiKey) =>
                          Text('Api Key: ${apiKey.substring(0, 10)}...'),
                        GoogleTextToSpeechUserService(
                          projectId: var projectId,
                          accessToken: var accessToken
                        ) =>
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VerticalSpace.small(),
                              Text('Project Id: $projectId'),
                              VerticalSpace.micro(),
                              Text(
                                  'Access Token: ${accessToken.substring(0, 10)}...'),
                            ],
                          )
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<ServicesBloc>().add(DeleteService(
                                  serviceId: switch (service) {
                                GeminiUserService(uid: var uid) => uid,
                                GoogleTextToSpeechUserService(uid: var uid) =>
                                  uid,
                              }));
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showRegisterGeminiDialog(BuildContext context) async {
    final TextEditingController apiKeyController = TextEditingController();

    if (context.mounted) {
      return showDialog(
        context: context,
        builder: (childContext) {
          return AlertDialog(
            title: const Text('Register Gemini Service'),
            content: TextField(
              controller: apiKeyController,
              decoration: const InputDecoration(
                hintText: 'AIza...',
                labelText: 'Api Key',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(childContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (apiKeyController.text.isNotEmpty) {
                    context.read<ServicesBloc>().add(
                        RegisterGeminiService(apiKey: apiKeyController.text));
                    Navigator.of(childContext).pop();
                  }
                },
                child: const Text('Register'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showRegisterTtsDialog(BuildContext context) async {
    final TextEditingController accessTokenController = TextEditingController();

    final TextEditingController projectIdController =
        TextEditingController(text: 'chatterbox-73d26');

    if (context.mounted) {
      return showDialog(
        context: context,
        builder: (childContext) {
          return AlertDialog(
            title: const Text('Register Google Text to Speech Service'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: accessTokenController,
                  decoration: const InputDecoration(
                    hintText: 'gcloud auth print-access-token',
                    labelText: 'Access Token',
                  ),
                ),
                VerticalSpace.small(),
                TextField(
                  controller: projectIdController,
                  decoration: const InputDecoration(
                    hintText: 'chatterbox-73d26',
                    labelText: 'Project Id',
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(childContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (accessTokenController.text.isNotEmpty &&
                      projectIdController.text.isNotEmpty) {
                    context.read<ServicesBloc>().add(RegisterGoogleTtsService(
                          projectId: projectIdController.text,
                          accessToken: accessTokenController.text,
                        ));
                    Navigator.of(childContext).pop();
                  }
                },
                child: const Text('Register'),
              ),
            ],
          );
        },
      );
    }
  }
}
