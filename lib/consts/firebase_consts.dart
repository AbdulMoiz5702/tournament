




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String usersCollection = 'Users';
const String tournamentsCollection = 'Tournaments';
const String teamsCollection =  'Teams';
const String challengesCollection =  'challenges';
const String challengesTeamCollection =  'Teams';
const String chatsCollection =  'chats';
const String messagesCollection =  'messages';
const String status =  'status';
FirebaseFirestore fireStore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseAuth auth = FirebaseAuth.instance;
var currentUser = auth.currentUser;
var userToken = '444444';