import 'dart:async';
import 'dart:io';
import 'package:blockbill/ui/EnterDetails/enter_details.dart';
import 'package:blockbill/utils/widgets/next_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';
import 'dart:math';
import 'package:path/path.dart' as Path;

class ScanBill extends StatefulWidget {
  @override
  _ScanBillState createState() => _ScanBillState();
}

class _ScanBillState extends State<ScanBill> {

  PickedFile _file;
  List<VisionText> _currentLabels = <VisionText>[];
  FirebaseVisionTextDetector detector = FirebaseVisionTextDetector.instance;
  TextEditingController _editingController =  TextEditingController();
  bool isLoading;
  double total = 0;

  @override
  void initState() {
    super.initState();
    getImage();
    setState(() => isLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BlockBill'),
          centerTitle: true,
        ),
        floatingActionButton: NextButton(
          gradient: LinearGradient(
            colors: [Color(0xff006EE0), Color(0xff0038AE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => EnterDetails(total: total, file: _file))),
        ),
        body: _buildBody()
    );
  }

  void getImage() async {
    try {
      var file = await ImagePicker().getImage(source: ImageSource.camera);
      setState(() => _file = file);
      try {
        var currentLabels = await detector.detectFromPath(_file?.path);
        setState(() => _currentLabels = currentLabels);
        try {
          total = getTotalAmount(_currentLabels);
        } catch (e) {
          total = 0;
          print(e);
        }
        if(_file!=null) uploadImageToFirebase(context);
        setState(() => isLoading = false);
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildImage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.50,
      child: new Center(
        child: _file == null
            ? Text('Loading')
            : new FutureBuilder<Size>(
          future: _getImageSize(Image.file(File(_file.path), fit: BoxFit.fitWidth)),
          builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
            if (snapshot.hasData) {
              return Container(
                  foregroundDecoration: TextDetectDecoration(_currentLabels, snapshot.data),
                  child: Image.file(File(_file.path), fit: BoxFit.fitWidth));
            } else {
              return new Text('Detecting...');
            }
          },
        ),
      ),
    );
  }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = new Completer<Size>();
    image.image
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(Size(info.image.width.toDouble(), info.image.height.toDouble()));
    }));
    return completer.future;
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
              children: <Widget>[
          _buildImage(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                    child: _buildList(_currentLabels)
                ),
          if(_file == null) Container()
          else isLoading ?
          Center(child: CircularProgressIndicator()) :
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text('Total:'),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 15.0),
                  margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: TextField(
                      decoration: InputDecoration(border: InputBorder.none, hintText: total.toString()),
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        total = double.parse(value);
                      },
                      controller: _editingController),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  
  getTotalAmount(List<VisionText> texts) {
    List<double> prices = [];
    texts.forEach((text) {
      if(RegExp("(\\d+(?:\\.\\d+))", multiLine: true).hasMatch(text.text)){
        double price = double.tryParse(text.text);
        if(price != null) prices.add(price);
      }
    });
    print(prices.reduce(max));
    return prices.reduce(max);
  }

  Widget _buildList(List<VisionText> texts) {
    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.all(1.0),
          shrinkWrap: true,
          itemCount: texts.length,
          itemBuilder: (context, i) {
            return _buildRow(texts[i].text);
          }),
    );
  }

  Widget _buildRow(String text) {
    return ListTile(
      title: Text('item: $text', style: Theme.of(context).textTheme.subtitle1,),
      dense: true,
    );
  }

  Future uploadImageToFirebase(BuildContext context) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('bills/${Path.basename(_file.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(File(_file.path));
    await uploadTask.onComplete;
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        print(fileURL);
        return _uploadedFileUrl = fileURL;
      });
  }
}

class TextDetectDecoration extends Decoration {
  final Size _originalImageSize;
  final List<VisionText> _texts;
  TextDetectDecoration(List<VisionText> texts, Size originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return new _TextDetectPainter(_texts, _originalImageSize);
  }
}

class _TextDetectPainter extends BoxPainter {
  final List<VisionText> _texts;
  final Size _originalImageSize;

  _TextDetectPainter(texts, originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = new Paint()
      ..strokeWidth = 2.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    final _heightRatio = _originalImageSize.height / configuration.size.height;
    final _widthRatio = _originalImageSize.width / configuration.size.width;
    for (var text in _texts) {
      final _rect = Rect.fromLTRB(
          offset.dx + text.rect.left / _widthRatio,
          offset.dy + text.rect.top / _heightRatio,
          offset.dx + text.rect.right / _widthRatio,
          offset.dy + text.rect.bottom / _heightRatio);
      canvas.drawRect(_rect, paint);
    }
    canvas.restore();
  }
}
