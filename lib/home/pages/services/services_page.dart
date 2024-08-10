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
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        if(!state.enabled) {
          // todo user must request to be enabled
          return const Placeholder();
        }
        var registeredServices = state.userServices.toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Manage Your Services',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              VerticalSpace.small(),
              if (!state.userServices.containsGeminiService) ...[
                VerticalSpace.small(),
                ElevatedButton(
                  onPressed: () => context
                      .read<ServicesBloc>()
                      .add(const RegisterGeminiService(enabled: true)),
                  child: const Text('Register Gemini Service'),
                ),
              ],
              if (!state.userServices.containsGoogleTextToSpeechService) ...[
                VerticalSpace.small(),
                ElevatedButton(
                  onPressed: () =>
                      _showRegisterTtsDialog(context: context, enabled: true),
                  child: const Text('Register Google Text to Speech Service'),
                ),
              ],
              if (!state.userServices.containsRecorderService) ...[
                VerticalSpace.small(),
                ElevatedButton(
                  onPressed: () => context
                      .read<ServicesBloc>()
                      .add(const RegisterRecorderService(enabled: true)),
                  child: const Text('Register Audio Recorder Service'),
                ),
              ],
              VerticalSpace.small(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.userServices.length,
                itemBuilder: (context, index) {
                  final service = registeredServices[index];
                  return Card(
                    child: switch (service) {
                      GeminiUserService() =>
                        _buildGeminiServiceTile(context, service),
                      GoogleTextToSpeechUserService() =>
                        _buildGoogleTtsServiceTile(context, service),
                      RecorderUserService() => _buildRecorderServiceTile(context, service),
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGeminiServiceTile(
      BuildContext context, GeminiUserService service) {
    return ListTile(
      leading: Image.asset(
        Assets.geminiIcon,
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
      ),
      title: const Text('Gemini Service'),
      trailing: Switch(
        value: service.enabled,
        thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const Icon(Icons.check);
            }
            return const Icon(Icons.close);
          },
        ),
        activeColor: Theme.of(context).colorScheme.primaryContainer,
        onChanged: (state) {
          context
              .read<ServicesBloc>()
              .add(RegisterGeminiService(enabled: state));
        },
      ),
    );
  }

  Widget _buildRecorderServiceTile(
      BuildContext context, RecorderUserService service) {
    return ListTile(
      leading: Icon(Icons.fiber_smart_record, color: HSLColor.fromColor(Colors.red).withLightness(0.4).toColor(),),
      title: const Text('Audio Recorder Service'),
      trailing: Switch(
        value: service.enabled,
        thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const Icon(Icons.check);
            }
            return const Icon(Icons.close);
          },
        ),
        activeColor: Theme.of(context).colorScheme.primaryContainer,
        onChanged: (state) {
          context
              .read<ServicesBloc>()
              .add(RegisterRecorderService(enabled: state));
        },
      ),
    );
  }

  Widget _buildGoogleTtsServiceTile(
      BuildContext context, GoogleTextToSpeechUserService service) {
    return ListTile(
      leading: const Icon(
        Icons.spatial_audio_off_rounded,
        color: Colors.grey,
      ),
      title: const Text('Google Text To Speech Service'),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VerticalSpace.small(),
          Text('Project Id: ${service.projectId}'),
          VerticalSpace.micro(),
          Text('Access Token: ${service.accessToken.substring(0, 10)}...'),
        ],
      ),
      onTap: () => _showRegisterTtsDialog(
        context: context,
        enabled: service.enabled,
        projectId: service.projectId,
        accessToken: service.accessToken,
      ),
      trailing: Switch(
        value: service.enabled,
        thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const Icon(Icons.check);
            }
            return const Icon(Icons.close);
          },
        ),
        activeColor: Theme.of(context).colorScheme.primaryContainer,
        onChanged: (state) {
          context.read<ServicesBloc>().add(RegisterGoogleTtsService(
              projectId: service.projectId,
              accessToken: service.accessToken,
              enabled: state));
        },
      ),
    );
  }

  Future<void> _showRegisterTtsDialog({
    required BuildContext context,
    required bool enabled,
    String? projectId,
    String? accessToken,
  }) async {
    final TextEditingController accessTokenController = TextEditingController(text: accessToken);

    final TextEditingController projectIdController =
        TextEditingController(text: projectId ?? 'chatterbox-73d26');

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
                      accessTokenController.text.length > 10 &&
                      projectIdController.text.isNotEmpty) {
                    context.read<ServicesBloc>().add(RegisterGoogleTtsService(
                          projectId: projectIdController.text,
                          accessToken: accessTokenController.text,
                          enabled: enabled,
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
