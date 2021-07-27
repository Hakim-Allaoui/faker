import 'dart:io';

import 'package:faker/providers/firestore_helper.dart';
import 'package:faker/utils/auth.dart';
import 'package:faker/utils/navigator.dart';
import 'package:faker/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/appbar.dart';
import 'package:faker/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AuthMode { SignUp, Login }

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'username': '',
  };
  var _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  InputBorder _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(100.0),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmExit,
      child: Scaffold(
        key: scaffoldKey,
        drawer: HKDrawer(scaffoldKey: scaffoldKey),
        body: Column(
          children: [
            CustomAppBar(
              scaffoldKey: scaffoldKey,
              title: Text(
                Tools.packageInfo.appName,
                style: MyTextStyles.bigTitleBold,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                        color: Palette.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            // spreadRadius: 5.0,
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'email'.tr().replaceAll("\\n", "\n"),
                          style: MyTextStyles.titleBold,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'invalid_email'.tr();
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['email'] = value;
                            },
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: MyTextStyles.title,
                            decoration: InputDecoration(
                              filled: true,
                              border: _inputBorder,
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: 'Exemple@gmail.com',
                              suffix: InkWell(
                                onTap: () => _emailController.clear(),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Colors.black,
                                  ),
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 10.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _authMode == AuthMode.SignUp
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'username'.tr().replaceAll("\\n", "\n"),
                                    style: MyTextStyles.titleBold,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Center(
                                      child: TextFormField(
                                        validator: _authMode == AuthMode.SignUp
                                            ? (value) {
                                                if (value.isEmpty ||
                                                    value == ' ' ||
                                                    value.contains(' ')) {
                                                  return 'invalid_username'
                                                      .tr();
                                                }
                                                return null;
                                              }
                                            : null,
                                        onSaved: (value) {
                                          _authData['username'] = value;
                                        },
                                        enabled: _authMode == AuthMode.SignUp,
                                        style: MyTextStyles.title,
                                        decoration: InputDecoration(
                                          border: _inputBorder,
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          filled: true,
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          hintText: 'username'.tr().replaceAll("\\n", "\n"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        Text(
                          'password'.tr().replaceAll("\\n", "\n"),
                          style: MyTextStyles.titleBold,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty || value.length < 8) {
                                return 'password_is_too_short'.tr();
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['password'] = value;
                            },
                            obscureText: true,
                            controller: _passwordController,
                            style: MyTextStyles.title,
                            decoration: InputDecoration(
                              border: _inputBorder,
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: '••••••••',
                              suffix: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.black,
                                ),
                                child: InkWell(
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 10.0,
                                  ),
                                  onTap: () => _passwordController.clear(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        _authMode == AuthMode.SignUp
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'confirm_Password'.tr().replaceAll("\\n", "\n"),
                                    style: MyTextStyles.titleBold,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: TextFormField(
                                        validator: _authMode == AuthMode.SignUp
                                            ? (value) {
                                                if (value !=
                                                    _passwordController.text) {
                                                  return 'passwords_do_not_match'
                                                      .tr();
                                                }
                                                return null;
                                              }
                                            : null,
                                        onSaved: (value) {
                                          _authData['password'] = value;
                                        },
                                        obscureText: true,
                                        enabled: _authMode == AuthMode.SignUp,
                                        style: MyTextStyles.title,
                                        decoration: InputDecoration(
                                          border: _inputBorder,
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          filled: true,
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          hintText: '••••••••',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: FlatButton(
                                  child: Text(
                                    '${_authMode == AuthMode.Login ? 'dont_have_account'.tr().replaceAll("\\n", "\n") : 'login_instead'.tr().replaceAll("\\n", "\n")}',
                                    style: MyTextStyles.subTitleBold
                                        .apply(color: Palette.gradient1),
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed:
                                      _isLoading ? null : _switchAuthMode,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
                            Container(
                              width: 2.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                color: Palette.greyLight,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 80.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: _isLoading ? 0.0 : 1.0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          gradient: RadialGradient(
                                            colors: [
                                              Palette.online,
                                              Palette.gradient1,
                                            ],
                                            center: Alignment.bottomLeft,
                                            radius: 2.0,
                                          ),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              height: 60.0,
                                              width: 60.0,
                                            ),
                                            _isLoading
                                                ? CircularProgressIndicator()
                                                : FlatButton(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20.0,
                                                            horizontal: 8.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.0),
                                                    ),
                                                    child: Text(
                                                      _authMode ==
                                                              AuthMode.Login
                                                          ? 'login'.tr().replaceAll("\\n", "\n")
: 'signup'.tr().replaceAll("\\n", "\n"),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    onPressed: _isLoading
                                                        ? null
                                                        : _submit,
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Login With [FACEBOOK] Button
                        Center(
                          child: Text(
                            'or'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.subTitleBold
                                .apply(color: Palette.greyDarken),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: _isLoading ? null : () async {
                              try {
                                await MyAuth.signInWithFacebook();
                                Posts.getUserPosts().then((value) => HKNavigator.goHome(context));
                              } on HttpException catch (error) {
                                var errorMessage = 'Authentication failed';
                                if (error.toString().contains('EMAIL_EXISTS')) {
                                  errorMessage =
                                      'This email address is already in use.';
                                } else if (error
                                    .toString()
                                    .contains('INVALID_EMAIL')) {
                                  errorMessage =
                                      'This is not a valid email address';
                                } else if (error
                                    .toString()
                                    .contains('WEAK_PASSWORD')) {
                                  errorMessage = 'This password is too weak.';
                                } else if (error
                                    .toString()
                                    .contains('EMAIL_NOT_FOUND')) {
                                  errorMessage =
                                      'Email or password is incorrect.';
                                } else if (error
                                    .toString()
                                    .contains('account already exists with the same email address but different sign-in credentials')) {
                                  errorMessage =
                                      'An account already exists with the same email address but different sign-in credentials.\nSign in using a provider associated with this email address.';
                                }
                                _showErrorDialog(errorMessage);
                              } on HandshakeException catch (error) {
                                const errorMessage = 'Connection terminated';
                                _showErrorDialog(errorMessage);
                                Tools.logger.e(error);
                              } catch (error) {
                                var errorMessage =
                                    'Could not authenticate you. Please try again later.';
                                if (error.toString().contains('Canceled')) {
                                  errorMessage = 'Canceled';
                                } else if (error
                                    .toString()
                                    .contains('per-user quota')) {
                                  errorMessage =
                                      'Error server 😵\nPlease try again later in less than 12hrs.';
                                }
                                _showErrorDialog(errorMessage);
                                Tools.logger.e(error);
                              }
                            },
                            child: Container(
                              // padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Palette.facebookBlue,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/fb_icon.svg',
                                    height: 30.0,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    'continue_with_facebook'.tr().replaceAll("\\n", "\n"),
                                    style: MyTextStyles.titleBold
                                        .apply(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: Text(
                            'you_can_also'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.subTitleBold
                                .apply(color: Palette.greyDarken),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Palette.move,
                                  gradient: RadialGradient(
                                    colors: Palette.gradientColors2,
                                    center: Alignment.bottomLeft,
                                    radius: 2.0,
                                  ),
                                ),
                                child: FlatButton(
                                  padding: EdgeInsets.all(20.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Text(
                                    'continue_anonymously'.tr().replaceAll("\\n", "\n"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                    // MyAuth.anonymousAuth();
                                    HKNavigator.goHome(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'an_error_occurred'.tr().replaceAll("\\n", "\n"),
          style: MyTextStyles.titleBold,
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: Tools.height * 0.15,
          width: Tools.width,
          child: Markdown(
            data: message,
            shrinkWrap: true,
            onTapLink: (link) async {
              Tools.launchURL(link);
            },
          ),
        ),
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(100.0),
                  gradient: RadialGradient(
                    colors: Palette.gradientColors2,
                    center: Alignment.bottomLeft,
                    radius: 2.0,
                  ),
                ),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text(
                    'ok'.tr().replaceAll("\\n", "\n"),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  loosAllFocuses() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  Future<void> _submit() async {
    loosAllFocuses();
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await MyAuth.signIn(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await MyAuth.signUp(
          _authData['email'],
          _authData['password'],
          _authData['username'],
        );
      }
      Posts.getUserPosts().then((value) => HKNavigator.goHome(context));
    } on HandshakeException catch (error) {
      Tools.logger.e(error);
      const errorMessage = 'Connection terminated';
      _showErrorDialog(errorMessage);
    } catch (error) {
      Tools.logger.e(error);
      var errorMessage = 'auth_failed'.tr();
      if (error.toString().contains('email-already-in-use')) {
        errorMessage = 'email-already-in-use'.tr();
      } else if (error.toString().contains('invalid-email')) {
        errorMessage = 'invalid-email'.tr();
      } else if (error.toString().contains('weak-password')) {
        errorMessage = 'weak-password'.tr();
      } else if (error.toString().contains('wrong-password')) {
        errorMessage = 'wrong-password'.tr();
      } else if (error.toString().contains('user-not-found')) {
        errorMessage = 'user-not-found'.tr();
      } else if (error.toString().contains('user-disabled')) {
        errorMessage = """
__${'account_suspended'.tr()}__


${'contact_us'.tr()} __[${Strings.contact_email}](mailto:${Strings.contact_email}?subject=Fake%20it%20Facebook%20post%20Maker%20Account_Suspended)__ ${'more_information'.tr()}.
        """;
      }
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> confirmExit() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'confirmation'.tr().replaceAll("\\n", "\n"),
              style: MyTextStyles.titleBold,
            ),
            content: new Text(
              'do_you_want_to_exit'.tr().replaceAll("\\n", "\n"),
              style: MyTextStyles.title,
            ),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(100.0),
                        color: Palette.greyDarken),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: new Text(
                        'exit'.tr().replaceAll("\\n", "\n"),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(100.0),
                      gradient: RadialGradient(
                        colors: Palette.gradientColors2,
                        center: Alignment.bottomLeft,
                        radius: 2.0,
                      ),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: new Text(
                        'cancel'.tr().replaceAll("\\n", "\n"),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )) ??
        false;
  }
}
