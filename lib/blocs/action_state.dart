import 'package:yt_dlp_wrapper/blocs/argument_state.dart';
import 'package:yt_dlp_wrapper/blocs/path_state.dart';

class ActionState {
  bool isLoading;
  bool isValid;

  PathState? pathState;
  ArgumentState? argumentState;

  ActionState({
    this.isLoading = false,
    this.isValid = false,
    this.pathState,
    this.argumentState,
  });

  ActionState copyWith({
    bool? isLoading,
    bool? isValid,
    PathState? pathState,
    ArgumentState? argumentState,
  }) =>
      ActionState(
        isLoading: isLoading ?? this.isLoading,
        isValid: isValid ?? this.isValid,
        pathState: pathState ?? this.pathState,
        argumentState: argumentState ?? this.argumentState,
      );
}
