import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_cart/providers/user_provider.dart';
import 'package:smart_cart/views/screens/authentication_screens/login_screen.dart';
import 'package:smart_cart/views/screens/main_screen.dart';

void main() {
  // Run the flutter app wrapped in a provider scope for managing state.
  runApp(ProviderScope(child: const MyApp()));
}

//Root widget of the application, a consumerWidget to consume state change
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // Method to check the token and set the user data if available
  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    // obtain an instance of sharedPreference for local data storage
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Retrive the authenticaion token and user data stored locally
    String? token = preferences.getString('auth_token');
    String? userJson = preferences.getString('user');

    //If both token and user data are available, update the user state
    if (token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: _checkTokenAndSetUser(ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final user = ref.watch(userProvider);

            return user!=null?MainScreen(): LoginScreen();
          }),
    );
  }
}
