import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import './user.dart';

class FeedbackMessage {
  final User user;
  final String message;
  final String sentiment;
  final Timestamp timestamp;

  FeedbackMessage({
    Key key,
    @required this.user,
    @required this.message,
    @required this.sentiment,
    @required this.timestamp,
  });
}
