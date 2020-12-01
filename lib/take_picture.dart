import 'dart:async';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/leaderboard.dart';
import 'package:kirk_app/question_screen.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:kirk_app/question_set.dart';
import 'dart:convert';

class TakePictureScreen extends StatefulWidget {
  static const String id = 'take_picture';

  final CameraDescription camera;

  static List<Question> holdQ;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  // Add two variables to the state class to store the CameraController and
  // the Future.
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(imagePath: path),
                ),
              );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Your Picture')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: FutureBuilder(
            future: getImage(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey[800],
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 60),
                          child: Image.file(File(imagePath)),
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Material(
                              elevation: 5.0,
                              color: Colors.blue[1000],
                              borderRadius: BorderRadius.circular(60.0),
                              child: MaterialButton(
                                onPressed: () {
                                  QuestionScreen.answers[ChallengeSelector.order-1].ans = snapshot.data;
                                  Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return QuestionScreen(
                                        questions: TakePictureScreen.holdQ,
                                      );
                                    }));
                                  },
                                minWidth: 200.0,
                                height: 42.0,
                                child: Text(
                                  'Send Picture!',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: font,
                                    color: Colors.red[200],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                      ]));
            }));
  }

  Future<String> getImage() async {
    var image = await FlutterImageCompress.compressWithFile(
      await File(imagePath).absolute.path,
      format: CompressFormat.jpeg,
      minWidth: 200,
      minHeight: 400,
      quality: 10,
    );
    return base64Encode(image.toList());
  }
}
