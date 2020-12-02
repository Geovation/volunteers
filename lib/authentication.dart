import 'package:flutter/material.dart';
import 'widgets.dart';
import 'map.dart';

enum ApplicationLoginState {
  loggedOut,
  loggedIn,
  resetPassword,
  register,
}

class Authentication extends StatelessWidget {
  final ApplicationLoginState loginState;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) signInWithEmailAndPassword;
  final void Function() signOut;
  final void Function() startResetFlow;
  final void Function(
    String email,
    void Function(Exception e) error,
  ) sendPasswordResetEmail;
  final void Function() cancel;
  final void Function() startRegisterAccountFlow;
  final void Function(
    String email,
    String displayName,
    String password,
    void Function(Exception e) error,
  ) registerAccount;

  const Authentication({
    @required this.loginState,
    @required this.signInWithEmailAndPassword,
    @required this.signOut,
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
      case ApplicationLoginState.loggedOut:
        return EmailPasswordForm(login: (email, password) {
          signInWithEmailAndPassword(email, password,
              (e) => _showErrorDialog(context, 'Failed to sign in', e));
        }, resetPassword: () {
          startResetFlow();
        }, registerAccount: () {
          startRegisterAccountFlow();
        });
      case ApplicationLoginState.loggedIn:
        return Map();
      case ApplicationLoginState.resetPassword:
        return EmailResetForm(
          cancel: () {
            cancel();
          },
          login: (email) {
            sendPasswordResetEmail(
                email, (e) => _showErrorDialog(context, 'Failed to submit', e));
          },
        );
      case ApplicationLoginState.register:
        return RegisterForm(
          cancel: () {
            cancel();
          },
          registerAccount: (
            email,
            displayName,
            password,
          ) {
            registerAccount(
                email,
                displayName,
                password,
                (e) =>
                    _showErrorDialog(context, 'Failed to create account', e));
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

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: Text(
              '${(e as dynamic).message}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          actions: <Widget>[
            StyledButton(
              child: Text(
                'OK',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class EmailPasswordForm extends StatefulWidget {
  final void Function(String email, String password) login;
  final void Function() resetPassword;
  final void Function() registerAccount;

  EmailPasswordForm({
    @required this.login,
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(35.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Image.asset('assets/heart.jpg'),
                SizedBox(
                  height: 10,
                ),
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
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                  onPressed: () {
                    widget.resetPassword();
                  },
                  child: Text('Forgot password?'),
                ),
                SizedBox(height: 8),
                FlatButton(
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    widget.registerAccount();
                  },
                  child: Text('Don\'t have an account?'),
                ),
              ],
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  padding: const EdgeInsets.only(top: 15.0),
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
    );
  }
}

class RegisterForm extends StatefulWidget {
  RegisterForm({
    @required this.registerAccount,
    @required this.cancel,
  });
  final void Function(String email, String displayName, String password)
      registerAccount;
  final void Function() cancel;
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      hintText: 'First & last name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your account name';
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
                          _displayNameController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    child: Text('CREATE'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 15.0),
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
    );
  }
}
