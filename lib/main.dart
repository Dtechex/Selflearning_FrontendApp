import 'package:flutter/material.dart';
import 'package:self_learning_app/features/category/bloc/category_bloc.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/features/login/data/repo/login_repo.dart';
import 'package:self_learning_app/features/login/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/login/bloc/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MyFormBloc>(
              create: (context) => MyFormBloc(loginRepo: LoginRepo())),
          BlocProvider<DashboardBloc>(create: (context) => DashboardBloc()),
          BlocProvider<CategoryBloc>(create: (context) => CategoryBloc()..add(CategoryLoadEvent())),
        ],
        child: MaterialApp(
            title: 'Self Learing',
            theme: ThemeData(
              snackBarTheme: SnackBarThemeData(
                backgroundColor: primaryColor,
              ),
              appBarTheme: const AppBarTheme(
                  centerTitle: true, backgroundColor: primaryColor),
              primarySwatch: Colors.blue,
            ),
            home: FutureBuilder(
              future: SharedPref().getToken(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return DashBoardScreen();
                } else {
                  return const LoginScreen();
                }
              },
            )));
  }
}
