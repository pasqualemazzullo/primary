import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/register_pet_provider.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import 'app_constants.dart';
import '../screens/startup/initial_screen.dart';

import '../screens/appointment/services/notification_service.dart';

class PrimaryApp extends StatelessWidget {
  const PrimaryApp({super.key});

  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationService().initialize();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.orange,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return ChangeNotifierProvider(
      create: (_) => RegisterPetProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Primary',
        theme: _buildAppTheme(),
        navigatorObservers: [AppConstants.routeObserver],
        home: const InitialScreen(),
      ),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Quicksand',
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.orange,
        selectionColor: AppColors.orange,
        selectionHandleColor: AppColors.orange,
      ),
    );
  }
}
