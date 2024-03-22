import 'dart:io';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/setting_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../camera/camera_manager.dart';
import '../../global.dart';
import '../tab/tab_page_rs.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  late CameraManager _cameraManager;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (kIsWeb) {
      barcodeReader.setParameters(scannerTemplate);
    }

    // Khởi tạo camera
    _cameraManager = CameraManager(
        context: context,
        cbRefreshUi: refreshUI,
        cbIsMounted: isMounted,
        cbNavigation: navigation);
    _cameraManager.initState();
  }

@override
  void dispose(){
    //Dừng camera khi widget bị dispose
    _cameraManager.stopVideo();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void navigation(dynamic order) {
    // Dừng camera trước khi chuyển trang
    _cameraManager.stopVideo();
    _cameraManager.isReadyToGo = false;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabPageResults(barcodeResults: order),
        ),
    ).then((value){
      // Khởi động lại camera sau khi quay trở lại từ ResultPage
      _cameraManager.resumeCamera();
    });
  }

  void refreshUI() {
    setState(() {});
  }

  bool isMounted() {
    return mounted;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraManager.controller == null ||
        !_cameraManager.controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraManager.controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _cameraManager.toggleCamera(0);
    }
  }

  List<Widget> createCameraPreview() {
    if (_cameraManager.controller != null &&
        _cameraManager.previewSize != null) {
      double width = _cameraManager.previewSize!.width;
      double height = _cameraManager.previewSize!.height;
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        if (MediaQuery.of(context).size.width <
            MediaQuery.of(context).size.height) {
          width = _cameraManager.previewSize!.height;
          height = _cameraManager.previewSize!.width;
        }
      }

      return [
        SizedBox(
            width: width, height: height, child: _cameraManager.getPreview()),
        Positioned(
          top: 0.0,
          right: 0.0,
          bottom: 0,
          left: 0.0,
          child: createOverlay(
            _cameraManager.barcodeResults,
          ),
        ),
      ];
    } else {
      return [const CircularProgressIndicator()];
    }
  }

  @override
  Widget build(BuildContext context) {
    var captureButton = InkWell(
      onTap: () {
        _cameraManager.isReadyToGo = true;
      },
      child: Image.asset('images/icon-capture.png', width: 80, height: 80),
    );

    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'Quét Mã',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    _cameraManager.pauseCamera();
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingPage()))
                        .then((value) {
                      _cameraManager.resumeCamera();
                    });
                  },
                  icon: const Icon(Icons.settings, color: Colors.white),
                ),
              )
            ],
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.white
            ),
          ),
          body: Stack(
            children: <Widget>[
              if (_cameraManager.controller != null &&
                  _cameraManager.previewSize != null)
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Stack(
                      children: createCameraPreview(),
                    ),
                  ),
                ),
              const Positioned(
                left: 122,
                right: 122,
                bottom: 20,
                child: Text('Powered by Hoang Kim',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
              ),
              Positioned(
                bottom: 45,
                left: 155,
                right: 155,
                child: captureButton,
              ),
            ],
          ),
          floatingActionButton: Opacity(
            opacity: 0.5,
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              child: const Icon(Icons.flip_camera_android),
              onPressed: () {
                _cameraManager.switchCamera();
              },
            ),
          ),
        ));
  }
}
