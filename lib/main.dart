import 'package:authentikate/view/registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:authentikate/model/network/network_helper.dart';
import 'view/login/bloc/login_bloc.dart';
import 'view/login/login_screen.dart';
import 'view/main_screen/main_screen.dart';
import 'view/registration/bloc/registration_bloc.dart';
import 'view/splash_screen/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => RegistrationBloc(ApiCall())),
            BlocProvider(create: (context) => LoginBloc(ApiCall())),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              useMaterial3: true,
            ),
            home: const SplashScreen(),
            routes: {
              '/registration': (context) => const RegistrationScreen(),
              '/login': (context) => const LoginScreen(),
              '/main': (context) => const MainScreen(),
            },
          ),
        );
      },
    );
  }
}
