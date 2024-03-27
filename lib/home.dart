import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;
  bool cameraPermissionGranted = false;
  bool locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async => await requestPermissions());
  }

  Future<void> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final locationStatus = await Permission.location.request();
    // print(cameraStatus);
    // print(locationStatus);
    setState(() {
      cameraPermissionGranted = cameraStatus.isGranted;
      locationPermissionGranted = locationStatus.isGranted;
    });

    if (!cameraPermissionGranted || !locationPermissionGranted) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Perizinan'),
              content:
                  const Text('Perizinan kameran dan lokasi anda belum hidup!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Tutup'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Buka Pengaturan Aplikasi'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraPermissionGranted || !locationPermissionGranted) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Perizinan Aplikasi",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Row(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 100.0,
                          color: Color(0xffff7643),
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          Icons.location_pin,
                          size: 100.0,
                          color: Color(0xffff7643),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Silakan izinkan akses kamera dan lokasi pada aplikasi anda. Agar aplikasi berjalan sempurna',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 20)),
                          elevation: const MaterialStatePropertyAll(0),
                          backgroundColor:
                              const MaterialStatePropertyAll(Color(0xffff7643)),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)))),
                      onPressed: () async {
                        await openAppSettings();
                      },
                      child: const Text(
                        'Buka Pengaturan Aplikasi',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              const Color(0xffff7643)),
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 20)),
                          elevation: const MaterialStatePropertyAll(0),
                          backgroundColor: const MaterialStatePropertyAll(
                              Colors.transparent),
                          shape:
                              MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Color(0xffff7643)),
                          ))),
                      onPressed: () async {
                        await requestPermissions();
                      },
                      child: const Text(
                        'Lanjutkan',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await inAppWebViewController.canGoBack();
        if (isLastPage) {
          inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                // url: Uri.parse("https://absensi-online.akuklik.id"),
                url: WebUri.uri(Uri.parse("https://absensi-online.akuklik.id")),
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  mediaPlaybackRequiresUserGesture: false,
                ),

                // Allow Video IN WEBVIEW
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                ),
                // crossPlatform: InAppWebViewOptions(
                //     // debuggingEnabled: true,
                //     // useShouldOverrideUrlLoading: true,
                //     // mediaPlaybackRequiresUserGesture: false,
                //     ),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) async {
                inAppWebViewController = controller;
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              androidOnGeolocationPermissionsShowPrompt:
                  (InAppWebViewController controller, String origin) async {
                return GeolocationPermissionShowPromptResponse(
                    origin: origin, allow: true, retain: true);
              },
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
            ),
            _progress < 1
                ? Container(
                    child: LinearProgressIndicator(
                      value: _progress,
                    ),
                  )
                : const SizedBox()
          ]),
        ),
      ),
    );
  }
}
