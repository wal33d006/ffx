import 'package:ffx/classifier.dart';
import 'package:flutter/material.dart';
import 'package:learning_text_recognition/learning_text_recognition.dart';
import 'package:learning_input_image/learning_input_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TextEditingController _controller;
  late Classifier _classifier;
  late List<Widget> _children;
  TextRecognition? _textRecognition = TextRecognition();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _classifier = Classifier();
    _children = [];
    _children.add(Container());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Text classification'),
        ),
        body: Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: <Widget>[
              // Expanded(
              //   child: InputCameraView(
              //     canSwitchMode: false,
              //     mode: InputCameraMode.gallery,
              //     title: '',
              //     onImage: (InputImage image) async {
              //       var data = await _textRecognition?.process(image);
              //       print(data?.text);
              //       _sendTextToClassifier(data!.text);
              //     },
              //   ),
              // ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _children.length,
                itemBuilder: (_, index) {
              return _children[index];
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _sendTextToClassifier(_controller.text);
                    },
                    child: const Icon(Icons.send),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendTextToClassifier(String data) {
    final prediction = _classifier.classify(data);
    setState(() {
      _children.add(Dismissible(
        key: GlobalKey(),
        onDismissed: (direction) {},
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: prediction[1] > prediction[0] ? Colors.lightGreen : Colors.redAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Input: ${data}",
                  style: const TextStyle(fontSize: 16),
                ),
                if (prediction[1] > prediction[0])
                  const Text("   Positive")
                else
                  const Text("   Negative"),
              ],
            ),
          ),
        ),
      ));
      _controller.clear();
    });
  }
}
