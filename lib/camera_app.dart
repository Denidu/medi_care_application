import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '';
import 'camera_toggles_row.dart';


class CameraProvider extends StateNotifier<List<CameraDescription>> {
  CameraProvider() : super([]);

  Future<void> initializeCamera() async {
    final cameras = await availableCamera();
    state = cameras;
  }
}

final cameraProvider = Provider((ref) => CameraProvider());

class CameraExampleHome extends StatefulWidget {
  const CameraExampleHome({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  _CameraExampleHomeState createState() => _CameraExampleHomeState();
}

class _CameraExampleHomeState extends State<CameraExampleHome>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? imagefile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.grey,
                  width: 3.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: CameraPreviewWidget(controller),
                ),
              ),
            ),
          ),
          CaptureControlRowWidget(controller, onTakePictureButtonPressed),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                CameraTogglesRowWidget(
                  controller,
                  widget.cameras,
                  onNewCameraSelected,
                ),
                ThumbnailWidget(imagefile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final oldController = controller;
    if (oldController != null) {
      controller = null;
      await oldController.dispose();
    }
  }

  final cameraController = CameraController(
    cameraDescription,
    ResolutionPreset.high,
    imageFormatGroup: ImageFormatGroup.jpeg,
  );

  controller = cameraController;
  
 
  
  cameraController.addListener((){
    if (mounted){
      setState((){});
    }
    if(cameraController.value.hasError){
      print('Camera Error ${cameraController.value.errorDescription}');
    }
  });

  try{
    await cameraController.initialize();
  } catch (e){
    switch(e.code){
      case 'CameraAccessDenied':
      print('You have denied camera access');
      break;
      case 'CamaraAcessDeniedWithoutPrompt':
      print('Enable camera');
      break;
      case 'CameraAccessRestricted':
      print('Camera access restricted');
      break;
      default:
      break;

    }
  }
}

Future<void>onTakePictureButtonPressed() async{
  final picture = await takePicture();
  if(picture != null){
    print('Picture saved to ${picture.path}');
  }
}

Future<XFile?> takePicture() async{
  final cameraController = controller;
  if (cameraController== null || !cameraController.value.isInitialized){
    print('Error: Select the Camera first');
    return null;
  }

  if(cameraController.value.isTakingPicture){
    return null;
  }
  try{
    final XFile file = await cameraController.takingPicture();
    return file;
  }on CameraException catch (e){
    print('Camera Error : ${e.toString()}');
    return null;
  }
}

class CameraApp extends StatelessWidget {
  const CameraApp({Key? key, required this.cameras}):super(key: key);

  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraExampleHome(cameras: cameras),
    );
  }
}



