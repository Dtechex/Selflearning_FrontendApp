import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:self_learning_app/features/category/bloc/category_bloc.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/features/login/data/repo/login_repo.dart';
import 'package:self_learning_app/features/login/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/quick_add/data/bloc/quick_add_bloc.dart';
import 'package:self_learning_app/features/registration/bloc/signup_bloc.dart';
import 'package:self_learning_app/features/registration/data/repo/signup_repo.dart';
import 'package:self_learning_app/features/search_category/bloc/search_cat_bloc.dart';
import 'package:self_learning_app/features/subcategory/bloc/sub_cate_bloc.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';
import 'features/camera/bloc/camera_bloc.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/login/bloc/login_bloc.dart';



void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(), // Wrap your app
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MyFormBloc>(
              create: (context) => MyFormBloc(loginRepo: LoginRepo())),
          BlocProvider<DashboardBloc>(create: (context) => DashboardBloc()),
          BlocProvider<CategoryBloc>(
              create: (context) => CategoryBloc()..add(CategoryLoadEvent())),
          BlocProvider<SearchCategoryBloc>(
              create: (context) => SearchCategoryBloc()),
          BlocProvider<SubCategoryBloc>(create: (context) => SubCategoryBloc()),
          BlocProvider<SignUpBloc>(create: (context) => SignUpBloc(singUpRepo: SignUpRepo())),
          BlocProvider<CameraBloc>(create: (context) => CameraBloc()),
          BlocProvider<QuickAddBloc>(create: (context) => QuickAddBloc()),

        ],
        child: MaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
            title: 'Self Learing',
            theme: ThemeData(floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: primaryColor
            ),

              iconTheme: const IconThemeData(
                color: primaryColor,
                weight: 2
              ),
              listTileTheme: const ListTileThemeData(
                iconColor: primaryColor
              ),
              elevatedButtonTheme: const ElevatedButtonThemeData(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(primaryColor))),
              snackBarTheme: const SnackBarThemeData(
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
                  return const DashBoardScreen();
                } else {
                  return const LoginScreen();
                }
              },
            )));
  }
}
