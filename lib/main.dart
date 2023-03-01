import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'Helper/LocalDatabase.dart';
import 'Provider/DeviceProvider.dart';
import 'Provider/IsServerConnectedProvider.dart';
import 'core/navigation/navigator.dart';
import 'features/app_home.dart';
import 'features/devices/domain/models/devices.dart';
import 'features/home/presentation/views/home.dart';
import 'features/routine/presentation/views/routine_home.dart';
import 'shared/res/res.dart';
import 'shared/widgets/onboarding_widget.dart';
import 'shared/widgets/page_indicator.dart';
import 'shared/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loadServerData();
    FlutterNativeSplash.remove();
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<DeviceProvider>(create: (context) => DeviceProvider()),
            ChangeNotifierProvider<IsServerConnectedProvider>(create: (context) => IsServerConnectedProvider()),
          ],
          child: OKToast(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Smart In',
              theme: SmartyThemeData.lightTheme,
              darkTheme: SmartyThemeData.darkTheme,
             // home: const MyHomePage(),
              home: const Dashboard(),
              onGenerateRoute: AppRouter.generateRoutes,
              navigatorKey: AppNavigator.key,
            ),
          ),
        );
      },
    );
  }
  Future<void> loadServerData() async {
    serverDomain=await LocalDatabase.getString(LocalDatabase.SERVER_DOMAIN);
    serverPort=await LocalDatabase.getString(LocalDatabase.SERVER_PORT);
    serverUserName=await LocalDatabase.getString(LocalDatabase.SERVER_USER_NAME);
    serverPassword=await LocalDatabase.getString(LocalDatabase.SERVER_PASSWORD);
    serverToken=await LocalDatabase.getString(LocalDatabase.SERVER_TOKEN);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController? _pageController;
  Timer? _pageAnimationTimer;
  int _page = 0;

  void _animatePages() {
    if (_pageController == null) return;
    if (_page < 2) {
      _pageController?.nextPage(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageAnimationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _animatePages();
    });
  }

  @override
  void dispose() {
    _pageAnimationTimer?.cancel();
    _pageAnimationTimer = null;
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 9,
              child: PageView(
                controller: _pageController,
                onPageChanged: (newPage) {
                  setState(() {
                    _page = newPage;
                  });
                },
                children: const [
                  OnboardingWidget(
                    image: 'assets/images/home1.png',
                    title: 'Smart',
                    subtitle: 'Manage the power usage of all your electronic device at your convinience',
                  ),
                  OnboardingWidget(
                    image: 'assets/images/home2.png',
                    title: 'Control',
                    subtitle:
                        'Control all your electronic devices with at a single click with just your smart phone',
                  ),
                  OnboardingWidget(
                    image: 'assets/images/home3.png',
                    title: 'Autoomate',
                    subtitle: 'Create routines and schedule devices to run along with your routine',
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 4,
                child: Column(
                  children: [
                    SizedBox(height: 64.h),
                    PageIndicatorWidget(
                      count: 3,
                      value: _page,
                      size: 12.w,
                    ),
                    SizedBox(height: 64.h),
                    AppButtonPrimary(
                      label: 'Get Started',
                      onPressed: () =>
                          AppNavigator.pushNamedReplacement(loginRoute),
                    ),
                    // SizedBox(height: 42.h),
                  ],
                ))
          ],
        ),
      ),
    );
  }


}
