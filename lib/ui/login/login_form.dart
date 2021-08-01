import 'package:flutter/material.dart';
import 'package:websocket_tester/ui/ulti/responsive_screen.dart';

import 'package:sizer/sizer.dart';

class LoginForm extends StatefulWidget {
  // const LoginForm({ Key? key }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late Screen size;

  @override
  void initState() {
    // _usernameController.;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
            top: true,
            bottom: false,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    // margin: EdgeInsets.symmetric(
                    //   horizontal: size.getWithPx(20),
                    //   vertical: size.getWithPx(20),
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        _formWidget(context),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _formWidget(context) {
    return Container(
      width: double.infinity,
      height: Screen(MediaQuery.of(context).size).getWithPx(200),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              icon: Icon(
                Icons.email,
                // color: colorCurve,
              ),
              labelText: 'username',
            ),
            // validator: (_) {
            //   return !state.isUsernameValid ? 'Invalid username' : null;
            // },
            autocorrect: false,
          ),
          SizedBox(
              height: new Screen(MediaQuery.of(context).size).getWithPx(8)),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock,
                // color: colorCurve,
              ),
              labelText: 'Password',
            ),
            obscureText: true,
            autovalidate: true,
            autocorrect: false,
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.login),
                label: Text("login"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
