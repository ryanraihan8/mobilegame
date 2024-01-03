import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:new_super_jumper/assets.dart';
import 'package:new_super_jumper/auth/appwrite.dart';
import 'package:new_super_jumper/auth/login_cred.dart';
import 'package:new_super_jumper/high_scores.dart';
import 'package:new_super_jumper/my_game.dart';
import 'package:new_super_jumper/navigation/routes.dart';
import 'package:new_super_jumper/ui/game_over_menu.dart';
import 'package:new_super_jumper/ui/main_menu_screen.dart';
import 'package:new_super_jumper/ui/pause_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  await HighScores.load();
  await Assets.load();
  await AuthHelper.instance.initialize();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      onGenerateRoute: Routes.routes,
    ),
  );
}

class MyGameWidget extends StatelessWidget {
  const MyGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MyGame(),
      overlayBuilderMap: {
        'GameOverMenu': (context, MyGame game) {
          return GameOverMenu(game: game);
        },
        'PauseMenu': (context, MyGame game) {
          return PauseMenu(game: game);
        }
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final LoginCredModel _loginCredModel = LoginCredModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 204, 204, 202),
      ),
      backgroundColor: Color.fromARGB(255, 204, 204, 202),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (newValue) => _loginCredModel.email = newValue!,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onSaved: (newValue) => _loginCredModel.password = newValue!,
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logging in...')),
                    );

                    try {
                      bool result =
                          await AuthHelper.instance.loginEmailPassword(
                        _loginCredModel.email!,
                        _loginCredModel.password!,
                      );
                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logged in')),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainMenuScreen()));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final LoginCredModel _loginCredModel = LoginCredModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: Color.fromARGB(255, 204, 204, 202),
      ),
      backgroundColor: Color.fromARGB(255, 204, 204, 202),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (newValue) => _loginCredModel.email = newValue!,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onSaved: (newValue) => _loginCredModel.password = newValue!,
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Creating user...')),
                    );

                    try {
                      bool result =
                          await AuthHelper.instance.signUpEmailPassword(
                        _loginCredModel.email!,
                        _loginCredModel.password!,
                      );

                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Create account')),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainMenuScreen()));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
                child: const Text('Create account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
