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
const String vsTeamCollection =  'vs';
const String status =  'status';
FirebaseFirestore fireStore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseAuth auth = FirebaseAuth.instance;
var currentUser = auth.currentUser;
var userToken = 'eBYLUqVcTjGrD8wP65YHDB:APA91bHbPZGnDV8kMAPkUYZiZbe9sUrQI4R-KSQqHRmB-hn_6FV31ylNO7EKpEghwiGG6aU4BW7iagHqmDv-aLY64M8bKAcqMS1mSFKuPqdTlhXvKZX0IuI';