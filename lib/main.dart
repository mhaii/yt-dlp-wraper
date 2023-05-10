import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_dlp_wrapper/blocs/action_cubit.dart';
import 'package:yt_dlp_wrapper/blocs/action_state.dart';
import 'package:yt_dlp_wrapper/blocs/argument_cubit.dart';
import 'package:yt_dlp_wrapper/blocs/argument_state.dart';
import 'package:yt_dlp_wrapper/blocs/path_cubit.dart';
import 'package:yt_dlp_wrapper/blocs/path_state.dart';
import 'package:yt_dlp_wrapper/components/dialogs/loading_dialog.dart';
import 'package:yt_dlp_wrapper/di.dart';
import 'package:yt_dlp_wrapper/navigator.dart';
import 'package:yt_dlp_wrapper/pages/home_page.dart';

void main() async {
  await DI.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'yt-dlp wrapper',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      // themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => PathCubit()),
        BlocProvider(create: (ctx) => ArgumentCubit()),
        BlocProvider(create: (ctx) => ActionCubit()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PathCubit, PathState>(
            listener: (context, state) =>
                context.read<ActionCubit>().updatePathState(state),
          ),
          BlocListener<ArgumentCubit, ArgumentState>(
            listener: (context, state) =>
                context.read<ActionCubit>().updateArgumentState(state),
          ),
          BlocListener<ActionCubit, ActionState>(
            listenWhen: (prev, cur) => prev.isLoading != cur.isLoading,
            listener: (context, state) =>
                (state.isLoading) ? LoadingDialog.show() : LoadingDialog.hide(),
          ),
        ],
        child: app,
      ),
    );
  }
}
