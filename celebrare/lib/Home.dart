import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ImagePicker picker = ImagePicker();
  File? image;
  var frameSelected = 1; // Store the selected frame
  double blurSigmaX = 10.0; // Blur intensity for the frame
  double blurSigmaY = 10.0;

  void clearImageAndLogs() {
    setState(() {
      image = null; // Clear the selected image
      frameSelected = 1; // Reset the selected frame
    });
    print('Logs cleared');
  }

  void showCroppedImagePopup(File? imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            width: 300,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        clearImageAndLogs();
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Icon(
                        Icons.cancel,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Text('Uploaded Image'),
                Container(
                  child: imageFile != null
                      ? OverlayFrameImage(
                    image: imageFile,
                    frameSelected: frameSelected,
                    blurSigmaX: blurSigmaX,
                    blurSigmaY: blurSigmaY,
                  )
                      : Text('No image found'),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        frameSelected = 0;
                      },
                      child: Text('Original'),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        setState(() {
                          frameSelected = 1;
                          Navigator.of(context).pop();
                        });
                      },
                      child: Frame(f: 1),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        setState(() {
                          frameSelected = 2;
                          Navigator.of(context).pop();
                        });
                      },
                      child: Frame(f: 2),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        setState(() {
                          frameSelected = 3;
                          Navigator.of(context).pop();
                        });
                      },
                      child: Frame(f: 3),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        setState(() {
                          frameSelected = 4;
                          Navigator.of(context).pop();
                        });
                      },
                      child: Frame(f: 4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future pickImage() async {
    try {
      final XFile? pickedImage =
      await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        // Crop the selected image
        final croppedImage = await cropImage(pickedImage.path);

        if (croppedImage != null) {
          setState(() {
            image = File(croppedImage.path);
            frameSelected = 1; // Reset the selected frame
            showCroppedImagePopup(image);
          });
        }
      }
    } on PlatformException catch (e) {
      print('Failed to pick an image: $e');
    }
  }

  Future<XFile?> cropImage(String filePath) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedImage != null) {
      return XFile(croppedImage.path);
    } else {
      print('Failed to crop image');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF0C9A8F),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.grey,
        ),
        title: Center(
          child: Text(
            'Add Image/ Icon',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.only(top: 8),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 100,
                    right: 100,
                    top: 40,
                    bottom: 5,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          "Upload Image",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          pickImage();
                        },
                        child: Text('Choose from Device'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF0C9A8F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (image != null)
                Stack(
                  children: [
                    if (frameSelected >1)
                      ClipPath(
                        clipper: frameSelected == 4
                            ? RectangleShapeClipper()
                            : frameSelected == 3
                            ? CircleShapeClipper()
                            : frameSelected == 2
                            ? SquareShapeClipper()
                            : null,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: blurSigmaX, sigmaY: blurSigmaY),
                          child: Container(
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    else if (frameSelected == 1)
                      Container(
                        child: Stack(
                          children: [
                            Image.asset('assets/heart.png'),
                            Image.file(
                              image!,

                            ),
                            Image.asset('assets/heart.png'),
                             
                          ],
                        ),
                      )
                    // else
                    //   Image.file(
                    //     image!,
                    //     fit: BoxFit.cover,
                    //   ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Frame extends StatelessWidget {
  final int f;

  const Frame({Key? key, required this.f}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Image.asset(
        'assets/$f.png',
        width: 30,
        height: 30,
        fit: BoxFit.cover,
      ),
    );
  }
}

class CircleShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(
        Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class SquareShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromPoints(Offset.zero, Offset(size.width, size.height)));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class RectangleShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromPoints(Offset.zero, Offset(size.width, size.height - 50)));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class OverlayFrameImage extends StatelessWidget {
  final File image;
  final int frameSelected;
  final double blurSigmaX;
  final double blurSigmaY;

  OverlayFrameImage({
    required this.image,
    required this.frameSelected,
    this.blurSigmaX = 10.0,
    this.blurSigmaY = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: frameSelected == 1
              ? RectangleShapeClipper()
              : frameSelected == 2
              ? CircleShapeClipper()
              : frameSelected == 5
              ? RectangleShapeClipper()
              : null,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY),
            child: Container(
              width: 200, // Adjust width and height as needed
              height: 200,
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
