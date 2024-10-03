import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  File? image;
  late ImagePicker imagePicker;
  late ImageLabeler imageLabeler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    //ImageLabelerOptions options = 
    //ImageLabelerOptions(confidenceThreshold: 0.5);
    //labeler = ImageLabeler(options: options);
    loadModel();
  }

  loadModel() async {
    final modelPath = await getModelPath('assets/ml/pesos.tflite');
    final options = LocalLabelerOptions(
      confidenceThreshold: 0.8,
      modelPath: modelPath,
    );
    imageLabeler = ImageLabeler(options: options);
  }

  chooseImage() async {
    XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      image = File(selectedImage.path);
      performedImageLabeling();
      setState(() {
        image;
      });
    }
  }

  captureImage() async {
    XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      image = File(selectedImage.path);
      performedImageLabeling();
      setState(() {
        image;
      });
    }
  }

  String results = "";

  performedImageLabeling() async {
    InputImage inputImage = InputImage.fromFile(image!);

    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    results = "";

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      print(text);
      results += "$text      ${confidence.toStringAsFixed(2)}\n";
    }

    setState(() {
      results;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<String> getModelPath(String asset) async {
  final path = '${(await getApplicationSupportDirectory()).path}/$asset';
  await Directory(dirname(path)).create(recursive: true);
  final file = File(path);
  if (!await file.exists()) {
    final byteData = await rootBundle.load(asset);
    await file.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
  return file.path;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text("Cash Reader App"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                color: Colors.grey,
                margin: EdgeInsets.all(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: image == null
                      ? Icon(
                          Icons.image_outlined,
                          size: 150,
                        )
                      : Image.file(image!),
                ),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Colors.lightBlueAccent.shade400,
                child: Container(
                  height: 100,
                  child: Row(
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.image,
                          size: 50,
                        ),
                        onTap: () {
                          chooseImage();
                        },
                      ),
                      InkWell(
                        child: Icon(
                          Icons.camera,
                          size: 50,
                        ),
                        onTap: () {
                          captureImage();
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                ),
              ),
              Card(
                color: Colors.black,
                child: Container(
                  child: Text(results, style: TextStyle(fontSize: 24, color: Colors.white),),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                ),
                margin: EdgeInsets.all(10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
