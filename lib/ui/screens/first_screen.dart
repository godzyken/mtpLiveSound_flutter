import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mtp_live_sound/core/services/api.dart';

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  File _image;
  Uint8List _imageBytes;
  final picker = ImagePicker();
  CloudApi api;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.loadString('credentials.json').then((json) {
      api = CloudApi(json);
    });
  }

  void _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    print(pickedFile.path);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageBytes = _image.readAsBytesSync();
      } else {
        print('No image selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: _imageBytes == null
              ? Text('No Image selected')
              : Stack(
                  children: [
                    Image.memory(_imageBytes),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: _saveImage,
                        child: Text('Save to cloud'),
                      ),
                    )
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: 'Select image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  void _saveImage() async {
    final response = await api.save('test', _imageBytes);
    print(response.downloadLink);
  }
}
