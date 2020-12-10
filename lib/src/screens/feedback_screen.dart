import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteers/src/core/viewmodels/app_state.dart';
import 'package:volunteers/src/widgets/app_bar.dart';
import 'package:volunteers/src/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _sentiment = '';

  List<Widget> renderEmojiButtons() {
    Map<String, IconData> iconList = {
      "very dissatisfied": Icons.sentiment_very_dissatisfied,
      "dissatisfied": Icons.sentiment_dissatisfied,
      "satisfied": Icons.sentiment_satisfied,
      "very satisfied": Icons.sentiment_very_satisfied,
    };

    return iconList.entries
        .map(
          (mapEntry) => IconButton(
              iconSize: 50.0,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(mapEntry.value,
                  color: _sentiment == mapEntry.key
                      ? Theme.of(context).primaryColor
                      : Colors.black54),
              onPressed: () {
                setState(() {
                  _sentiment = mapEntry.key;
                });
              }),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Feedback'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset('assets/images/pencil.jpg'),
                  ),
                  SizedBox(height: 25.0),
                  Paragraph(
                      'We would like your feedback to improve our project.'),
                  SizedBox(height: 10.0),
                  Paragraph('How do you feel about this app?'),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ...renderEmojiButtons(),
                    ],
                  ),
                  SizedBox(height: 25.0),
                  Divider(
                    height: 8,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20.0),
                  Paragraph('Please leave you feedback below:'),
                  FeedbackForm(chosenSentiment: _sentiment),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  final String chosenSentiment;
  FeedbackForm({Key key, this.chosenSentiment}) : super(key: key);
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_FeedbackFormState');
  final _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _feedbackController,
              decoration: const InputDecoration(
                hintText: 'Enter your feedback',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your feedback to continue';
                }
                return null;
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
            width: double.infinity,
            child: StyledButton(
              onPressed: () {
                if (widget.chosenSentiment.length == 0) {
                  showErrorDialog(
                      context,
                      'Failed to submit',
                      Exception(
                          'No emoji chosen. How do you feel about the app?'));
                  return;
                }

                if (_formKey.currentState.validate()) {
                  FirebaseFirestore.instance
                      .collection('feedback')
                      .doc(context.read<AppState>().currentUser.uid)
                      .set({
                        'sentiment': widget.chosenSentiment,
                        'message': _feedbackController.text
                      })
                      .then((value) => showSuccessDialog(
                          context, 'Thanks for your feedback :)'))
                      .catchError(
                          (error) => print("Failed to add feedback: $error"));
                }
              },
              child: Text('SUBMIT'),
            ),
          ),
        ],
      ),
    );
  }
}
