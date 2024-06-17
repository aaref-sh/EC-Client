import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/routes/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'admin');
  final TextEditingController _passwordController =
      TextEditingController(text: 'admin');

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BaseRout(
      routeName: 'تسجيل الدخول',
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: size.width * .85,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  _buildTextField(
                      _usernameController, 'اسم المستخدم', Icons.person),
                  SizedBox(height: 20),
                  _buildTextField(
                      _passwordController, 'كلمة المرور', Icons.lock,
                      obscureText: true),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => _tryLogin(context),
                    child: Text('دخول'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity,
                          50), // double.infinity is the width and 50 is the height
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _tryLogin(BuildContext context) async {
    // validate fields
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      showErrorMessage(context, resAllFieldsRequired);
      return;
    }
    showLoadingPanel(context);
    // try to login
    Dio dio = Dio();
    try {
      var response = await dio.post("${host}Auth/Login", data: {
        'UserName': _usernameController.text,
        'Password': _passwordController.text
      });
      hideLoadingPanel(context);
      token = response.data['data']['token'];
      name = response.data['data']['userName'];
      navigateTo(context,
          type: PushMethod.replacement,
          to: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              primarySwatch: Colors.deepPurple,
              useMaterial3: true,
            ),
            home: const Directionality(
              textDirection: TextDirection.rtl,
              child: HomePage(),
            ),
          ));
    } on DioException catch (e) {
      hideLoadingPanel(context);
      if (e.response!.statusCode == 401) {
        showErrorMessage(context, 'خطأ بالمدخلات');
      } else {
        showErrorMessage(context, resError);
      }
    }
    // Your existing login logic
  }
}

class Login1 extends StatefulWidget {
  const Login1({super.key});

  @override
  State<Login1> createState() => _LoginState1();
}

class _LoginState1 extends State<Login1> {
  @override
  void initState() {
    super.initState();
  }

  var tfpass = TextEditingController(text: "admin");
  var tfname = TextEditingController(text: 'admin');
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BaseRout(
      routeName: 'تسجيل الدخول',
      child: Center(
        child: Container(
          width: size.width * .85,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color.fromARGB(255, 173, 173, 173))
                    // color: Colors.white,
                    ),
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 2, bottom: 2),
                padding: const EdgeInsets.only(left: 10, right: 20),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: const Color.fromARGB(255, 173, 173, 173),
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        textDirection: TextDirection.ltr,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: tfname,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'اسم المستخدم',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        textDirection: TextDirection.ltr,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: tfpass,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        tryLogin(context);
                      },
                      child: Text('دخول'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> tryLogin(BuildContext context) async {
    // validate fields
    if (tfname.text.isEmpty || tfpass.text.isEmpty) {
      showErrorMessage(context, resAllFieldsRequired);
      return;
    }
    showLoadingPanel(context);
    // try to login
    Dio dio = Dio();
    try {
      var response = await dio.post("${host}Auth/Login",
          data: {'UserName': tfname.text, 'Password': tfpass.text});
      hideLoadingPanel(context);
      token = response.data['data']['token'];
      navigateTo(context,
          type: PushMethod.replacement,
          to: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              primarySwatch: Colors.deepPurple,
              useMaterial3: true,
            ),
            home: const Directionality(
              textDirection: TextDirection.rtl,
              child: HomePage(),
            ),
          ));
    } on DioException catch (e) {
      hideLoadingPanel(context);
      if (e.response!.statusCode == 401) {
        showErrorMessage(context, 'خطأ بالمدخلات');
      } else {
        showErrorMessage(context, resError);
      }
    }
  }
}
