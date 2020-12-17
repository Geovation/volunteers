import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:volunteers/src/core/enums/app_state.dart';
import 'package:volunteers/src/widgets/widget.dart';
import 'package:volunteers/src/screens/map_screen.dart';

class Authentication extends StatelessWidget {
  final AppLoginState loginState;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) signInWithEmailAndPassword;
  final void Function(
    void Function(Exception e) error,
  ) signInWithGoogle;
  final void Function() startResetFlow;
  final void Function(
    String email,
    void Function(Exception e) error,
  ) sendPasswordResetEmail;
  final void Function() cancel;
  final void Function() startRegisterAccountFlow;
  final void Function(
    String email,
    String firstName,
    String lastName,
    String password,
    void Function(Exception e) error,
  ) registerAccount;

  const Authentication({
    @required this.loginState,
    @required this.signInWithEmailAndPassword,
    @required this.signInWithGoogle,
    @required this.startResetFlow,
    @required this.sendPasswordResetEmail,
    @required this.cancel,
    @required this.startRegisterAccountFlow,
    @required this.registerAccount,
  });

  @override
  Widget build(BuildContext context) {
    print('loginState: $loginState');
    switch (loginState) {
      case AppLoginState.loggedOut:
        return EmailPasswordForm(
          login: (email, password) {
            signInWithEmailAndPassword(email, password,
                (e) => showErrorDialog(context, 'Failed to sign in', e));
          },
          signInWithGoogle: () {
            signInWithGoogle(
                (e) => showErrorDialog(context, 'Failed to sign in', e));
          },
          resetPassword: () {
            startResetFlow();
          },
          registerAccount: () {
            startRegisterAccountFlow();
          },
        );
      case AppLoginState.loggedIn:
        return MapScreen();
      case AppLoginState.resetPassword:
        return EmailResetForm(
          cancel: () {
            cancel();
          },
          login: (email) {
            sendPasswordResetEmail(
                email, (e) => showErrorDialog(context, 'Failed to submit', e));
          },
        );
      case AppLoginState.register:
        return RegisterForm(
          cancel: () {
            cancel();
          },
          registerAccount: (
            email,
            firstName,
            lastName,
            password,
          ) {
            registerAccount(email, firstName, lastName, password,
                (e) => showErrorDialog(context, 'Failed to create account', e));
          },
        );
      default:
        return Row(
          children: [
            Text("Internal error, this shouldn't happen..."),
          ],
        );
    }
  }
}

class EmailPasswordForm extends StatefulWidget {
  final void Function(String email, String password) login;
  final void Function() signInWithGoogle;
  final void Function() resetPassword;
  final void Function() registerAccount;

  EmailPasswordForm({
    @required this.login,
    @required this.signInWithGoogle,
    @required this.resetPassword,
    @required this.registerAccount,
  });

  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_EmailPasswordFormState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(35.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset('assets/images/heart.jpg'),
                  ),
                  SizedBox(height: 15),
                  Header('Welcome'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your email address to continue';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                    width: double.infinity,
                    child: StyledButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          widget.login(
                            _emailController.text,
                            _passwordController.text,
                          );
                        }
                      },
                      child: Text('SIGN IN'),
                    ),
                  ),
                  FlatButton(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      widget.resetPassword();
                    },
                    child: Text('Forgot password?'),
                  ),
                  FlatButton(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      widget.registerAccount();
                    },
                    child: Text('Don\'t have an account?'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    width: double.infinity,
                    child: StyledButton(
                      onPressed: () {
                        widget.signInWithGoogle();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/images/google-logo.png'),
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text('Sign in with Google'),
                          )
                        ],
                      ),
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
}

class EmailResetForm extends StatefulWidget {
  final void Function(String email) login;
  final void Function() cancel;

  EmailResetForm({
    @required this.login,
    @required this.cancel,
  });

  @override
  _EmailResetFormState createState() => _EmailResetFormState();
}

class _EmailResetFormState extends State<EmailResetForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_EmailResetFormState');
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(35.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Header('Reset Password'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your email address to continue';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 25.0),
                    width: double.infinity,
                    child: StyledButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          widget.login(
                            _emailController.text,
                          );
                        }
                      },
                      child: Text('SUBMIT'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8.0),
                    width: double.infinity,
                    child: StyledButton(
                      onPressed: () {
                        widget.cancel();
                      },
                      child: Text('CANCEL'),
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
}

class RegisterForm extends StatefulWidget {
  RegisterForm({
    @required this.registerAccount,
    @required this.cancel,
  });
  final void Function(
          String email, String firstName, String lastName, String password)
      registerAccount;
  final void Function() cancel;
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(35.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Header('Create Account'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your email address to continue';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        hintText: 'First name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        hintText: 'Last name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your last name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 25.0),
                    width: double.infinity,
                    child: StyledButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          widget.registerAccount(
                            _emailController.text,
                            _firstNameController.text,
                            _lastNameController.text,
                            _passwordController.text,
                          );
                        }
                      },
                      child: Text('CREATE'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8.0),
                    width: double.infinity,
                    child: StyledButton(
                      onPressed: () {
                        widget.cancel();
                      },
                      child: Text('CANCEL'),
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
}
