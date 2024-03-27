// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'ABSENSI ONLINE',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           useMaterial3: false,
//         ),
//         home: const Home());
//   }
// }

// class Home extends StatefulWidget {
//   const Home({
//     super.key,
//   });

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final controller = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setBackgroundColor(const Color(0x00000000))
//     ..setNavigationDelegate(
//       NavigationDelegate(
//         onProgress: (int progress) {
//           debugPrint('WebView is loading (progress : $progress%)');
//         },
//         onPageStarted: (String url) {
//           debugPrint('Page started loading: $url');
//         },
//         onPageFinished: (String url) {
//           debugPrint('Page finished loading: $url');
//         },
//         onWebResourceError: (WebResourceError error) {
//           debugPrint('''
//             Page resource error:
//               code: ${error.errorCode}
//               description: ${error.description}
//               errorType: ${error.errorType}
//               isForMainFrame: ${error.isForMainFrame}
//                       ''');
//         },
//         onNavigationRequest: (NavigationRequest request) {
//           if (request.url.startsWith('https://www.youtube.com/')) {
//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     )
//     ..loadRequest(Uri.parse('https://absensi-online.akuklik.id/'));

//   var statusCameraPermission = false;
//   var statusLocationPermission = false;

//   Future<void> checkPermission() async {
//     // camera permission
//     var statusCamera = await Permission.camera.request();
//     setState(() {
//       statusCameraPermission = statusCamera.isGranted;
//     });

//     // location permission
//     var statusLocation = await Permission.location.request();
//     setState(() {
//       statusLocationPermission = statusLocation.isGranted;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     checkPermission();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Keluar!'),
//               content:
//                   const Text('Apakah kamu ingin keluar dari aplikasi ini?'),
//               actions: <Widget>[
//                 TextButton(
//                   child: const Text('Tidak'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 TextButton(
//                   child: const Text('Ya'),
//                   onPressed: () => SystemNavigator.pop(),
//                 ),
//               ],
//             );
//           },
//         );
//         return false;
//       },
//       child: statusCameraPermission == true && statusLocationPermission == true
//           ? Scaffold(
//               body: SafeArea(child: WebViewWidget(controller: controller)),
//             )
//           : Scaffold(
//               appBar: AppBar(title: const Text("Perizinan")),
//               body: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 40),
//                       child: const Text(
//                           "Silahkan hidupkan perizinan lokasi dan akses kamera pada aplikasi anda!"),
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                     ElevatedButton(
//                         onPressed: () => openAppSettings(),
//                         child: const Text("Buka pengaturan perizinan"))
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
