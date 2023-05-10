import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_dlp_wrapper/blocs/action_cubit.dart';
import 'package:yt_dlp_wrapper/blocs/action_state.dart';
import 'package:yt_dlp_wrapper/blocs/argument_cubit.dart';
import 'package:yt_dlp_wrapper/blocs/argument_state.dart';

import 'package:yt_dlp_wrapper/blocs/path_cubit.dart';
import 'package:yt_dlp_wrapper/blocs/path_state.dart';
import 'package:yt_dlp_wrapper/components/file-selector.dart';
import 'package:yt_dlp_wrapper/components/format-quality-selector.dart';
import 'package:yt_dlp_wrapper/enums/arguments.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  //////////////////////////////////////////////////////////////////////////////

  String? getPathErrorMsg(PathValidationState validationState) {
    switch (validationState) {
      case PathValidationState.notExist:
        return 'Path is invalid';
      case PathValidationState.valid:
      case PathValidationState.empty:
        return null;
    }
  }

  String? getUrlErrorMsg(UrlValidationState validationState) {
    switch (validationState) {
      case UrlValidationState.invalid:
        return 'Url is invalid';
      case UrlValidationState.valid:
      case UrlValidationState.empty:
        return null;
    }
  }

  Future<void> onSelectingYtdlp(BuildContext context) async {
    final res = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['', 'exe']);

    if (context.mounted) {
      if (res != null) {
        context.read<PathCubit>().updateYtdlpPath(res.files[0].path!);
      }
    }
  }

  Future<void> onSelectingDest(BuildContext context) async {
    final destPath = await FilePicker.platform.getDirectoryPath();

    if (context.mounted) {
      if (destPath != null) {
        context.read<PathCubit>().updateDestPath(destPath);
      }
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  void onIsAudioOnlyUpdated(BuildContext context, bool? value) {
    context.read<ArgumentCubit>().setIsAudioOnly(!(value ?? true));
  }

  void onVideoQualityChanged(BuildContext context, int value) {
    context.read<ArgumentCubit>().updateVideoQuality(value);
  }

  void onVideoFormatChanged(BuildContext context, VideoFormat? value) {
    if (value != null) {
      context.read<ArgumentCubit>().updateVideoFormat(value);
    }
  }

  void onAudioQualityChanged(BuildContext context, int value) {
    context.read<ArgumentCubit>().updateAudioQuality(value);
  }

  void onAudioFormatChanged(BuildContext context, AudioFormat? value) {
    if (value != null) {
      context.read<ArgumentCubit>().updateAudioFormat(value);
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final pathInputs = BlocBuilder<PathCubit, PathState>(
      builder: (context, state) {
        return Column(
          children: [
            FileSelector(
              label: 'Path to yt-dlp executable',
              value: state.ytdlpPath,
              errorMsg: getPathErrorMsg(state.ytdlpState),
              onPressed: () => onSelectingYtdlp(context),
              onChanged: context.read<PathCubit>().updateYtdlpPath,
            ),
            FileSelector(
              label: 'Path to output to',
              value: state.destPath,
              errorMsg: getPathErrorMsg(state.destState),
              onPressed: () => onSelectingDest(context),
              onChanged: context.read<PathCubit>().updateDestPath,
            ),
          ],
        );
      },
    );

    final argumentInputs = BlocBuilder<ArgumentCubit, ArgumentState>(
      builder: (context, state) {
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: 'Source URL',
                errorText: getUrlErrorMsg(state.urlState),
              ),
              onChanged: context.read<ArgumentCubit>().updateUrl,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Video',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: !state.audioOnly,
                  onChanged: (value) => onIsAudioOnlyUpdated(context, value),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FormatQualitySelector(
                    isDisabled: state.audioOnly,
                    values: VideoFormat.values,
                    quality: state.videoQuality,
                    // onQualityChanged: (value) =>
                    //     onVideoQualityChanged(context, value),
                    format: state.videoFormat,
                    onFormatChanged: (value) =>
                        onVideoFormatChanged(context, value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Audio',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Checkbox(value: true, onChanged: null),
                const SizedBox(width: 12),
                Expanded(
                  child: FormatQualitySelector(
                    values: AudioFormat.values,
                    quality: state.audioQuality,
                    onQualityChanged: (value) =>
                        onAudioQualityChanged(context, value),
                    format: state.audioFormat,
                    onFormatChanged: (value) =>
                        onAudioFormatChanged(context, value),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    final actionBtn = BlocBuilder<ActionCubit, ActionState>(
      builder: (context, state) => ElevatedButton(
        onPressed: state.isValid ? context.read<ActionCubit>().fetch : null,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Download'),
        ),
      ),
    );

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        pathInputs,
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(),
        ),
        Row(
          children: [
            Expanded(child: actionBtn),
          ],
        ),
        argumentInputs,
      ],
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            constraints: const BoxConstraints.tightFor(width: 800),
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
