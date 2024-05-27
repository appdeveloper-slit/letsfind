// import 'package:firebase_remote_config/firebase_remote_config.dart';

// var allText;
// var apidata;

// class firebaseConfig {
//   final remoteConfig = FirebaseRemoteConfig.instance;

//   Future intializeFireBaseC() async {
//     await remoteConfig.setConfigSettings(
//       RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 1),
//         minimumFetchInterval: const Duration(seconds: 1),
//       ),
//     );
//     await remoteConfig.fetchAndActivate();
//     allText = remoteConfig.getString('alltext');
//     print(allText);
//     return allText;
//   }
// }
