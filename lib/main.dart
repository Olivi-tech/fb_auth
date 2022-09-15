import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(
          title: 'FaceBook',
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static String userEmail = '';
  static String name = '';
  static String picture = '';
  var myPic = picture;
  var myName = name;
  var myMail = userEmail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Firebase'),
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(name),
          Text(userEmail),
          // CircleAvatar(
          //   backgroundImage: NetworkImage(picture),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: ElevatedButton(
                onPressed: () async {
                  await signInWithFacebook();
                  setState(() {});
                },
                child: const Text('Login')),
          ),
          ElevatedButton(
              onPressed: () async {
                await FacebookAuth.instance.logOut();
                setState(() {});
              },
              child: const Text('Set state')),
        ])));
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult =
        await FacebookAuth.instance.login(permissions: [
      'email',
      'public_profile',
    ]);

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    var userData = await FacebookAuth.instance.getUserData();
    userEmail = userData['email'];
    //  myMail = userEmail;
    name = userData['name'];
    //  myName = name;
    picture = userData['public_profile'];
    // myPic = picture;
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
