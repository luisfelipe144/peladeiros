import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/game_controller.dart';
import 'controllers/placar_controller.dart';
import 'screens/splash_screen.dart';

void main() {
    runApp(
        MultiProvider(
            providers: [
                ChangeNotifierProvider(create: (_) => GameController()),
                ChangeNotifierProvider(create: (_) => PlacarController()),
            ],
            child: const MyApp(),
        ),
    );
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Torneio Fácil',
            theme: ThemeData(
                brightness: Brightness.dark,
                colorScheme: ColorScheme.dark(
                    primary: Colors.black,
                    secondary: Color(0xFFD4AF37),
                ),
                scaffoldBackgroundColor: Colors.black,
                appBarTheme: AppBarTheme(
                    backgroundColor: Colors.black,
                    iconTheme: IconThemeData(color: Colors.white),
                    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                    ),
                ),
                drawerTheme: DrawerThemeData(
                    backgroundColor: Colors.grey[900],
                ),
                textTheme: TextTheme(
                    bodyMedium: TextStyle(color: Colors.white),
                    bodySmall: TextStyle(color: Colors.white70),
                ),
            ),
            home: const SplashScreen(),
        );
    }
}
