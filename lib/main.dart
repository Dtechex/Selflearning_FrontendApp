import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:self_learning_app/features/add_promts/bloc/add_prompts_bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_bloc.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/features/login/data/repo/login_repo.dart';
import 'package:self_learning_app/features/login/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/quick_add/data/bloc/quick_add_bloc.dart';
import 'package:self_learning_app/features/quick_import/bloc/quick_add_bloc.dart';
import 'package:self_learning_app/features/quick_import/quick_add_import_screen.dart';
import 'package:self_learning_app/features/registration/bloc/signup_bloc.dart';
import 'package:self_learning_app/features/registration/data/repo/signup_repo.dart';
import 'package:self_learning_app/features/resources/bloc/resources_bloc.dart';
import 'package:self_learning_app/features/search_category/bloc/search_cat_bloc.dart';
import 'package:self_learning_app/features/subcategory/bloc/sub_cate_bloc.dart';
import 'package:self_learning_app/subcate1.1/bloc/sub_cate1_bloc.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/login/bloc/login_bloc.dart';
import 'features/subcate1.2/bloc/sub_cate2_bloc.dart';

BaseOptions baseOptions = BaseOptions(
  baseUrl: 'https://selflearning.dtechex.com/',
  receiveTimeout: const Duration(seconds: 90),
  sendTimeout: const Duration(seconds: 90),
  connectTimeout: const Duration(seconds: 90),
  responseType: ResponseType.json,
  maxRedirects: 3,
);
Dio dio = Dio(baseOptions);

void main() {
  dio.interceptors.add(LogInterceptor(
      responseBody: true,
      responseHeader: false,
      requestBody: true,
      request: true,
      requestHeader: true,
      error: true,
      logPrint: (text) {
        log(text.toString());
      }));
  runApp(
    const MyApp(), // Wrap your app
  );
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
          BlocProvider<CategoryBloc>(
              create: (context) => CategoryBloc()..add(CategoryLoadEvent())),
          BlocProvider<SignUpBloc>(
              create: (context) => SignUpBloc(singUpRepo: SignUpRepo())),
          BlocProvider<SearchCategoryBloc>(
              create: (context) => SearchCategoryBloc()),
          BlocProvider<SubCategoryBloc>(create: (context) => SubCategoryBloc()),
          //BlocProvider<CameraBloc>(create: (context) => CameraBloc()),
          BlocProvider<SubCategory1Bloc>(
              create: (context) => SubCategory1Bloc()),
          BlocProvider<SubCategory2Bloc>(
              create: (context) => SubCategory2Bloc()),
          BlocProvider<QuickImportBloc>(create: (context) => QuickImportBloc()),
          BlocProvider<ResourcesBloc>(create: (context) => ResourcesBloc()),
          // BlocProvider<AddPromptsBloc>(create: (context) => AddPromptsBloc()),
        ],
        child: GlobalLoaderOverlay(
          child: MaterialApp(
              useInheritedMediaQuery: true,
              locale: DevicePreview.locale(context),
              builder: DevicePreview.appBuilder,
              debugShowCheckedModeBanner: false,
              title: 'Self Learning',
              theme: ThemeData(
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                    backgroundColor: primaryColor),
                iconTheme: const IconThemeData(color: primaryColor, weight: 2),
                listTileTheme: const ListTileThemeData(iconColor: primaryColor),
                elevatedButtonTheme: const ElevatedButtonThemeData(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(primaryColor))),
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
              )),
        ));
  }
}
