import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starbucksapp/cubit/user_cubit.dart';
import 'package:starbucksapp/pages/commonpages/splash_page.dart';
import 'package:starbucksapp/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(),
      child: MaterialApp(
        title: 'Starbucks Demo App',
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.customTheme,
        home: SplashPage(),
      ),
    );
  }
}
