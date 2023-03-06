import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/app/app.dart';
import 'package:pos/gen/fonts.gen.dart';
import 'package:pos/home/view/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final ClientRepository _clientRepository;

  @override
  void initState() {
    super.initState();
    _clientRepository = ClientRepository();
  }

  @override
  void dispose() {
    _clientRepository.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _clientRepository,
      child: BlocProvider(
        create: (context) => AppCubit(prefs: widget.prefs),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: FontFamily.poppins,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

MaterialColor getMaterialColor(Color color) {
  final red = color.red;
  final green = color.green;
  final blue = color.blue;

  final shades = <int, Color>{
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.value, shades);
}
