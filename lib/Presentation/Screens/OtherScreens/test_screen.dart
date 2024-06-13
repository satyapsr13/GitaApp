import 'package:flutter/material.dart';

class TextFieldWithDynamicFontSize extends StatefulWidget {
  @override
  _TextFieldWithDynamicFontSizeState createState() =>
      _TextFieldWithDynamicFontSizeState();
}

class _TextFieldWithDynamicFontSizeState
    extends State<TextFieldWithDynamicFontSize> {
  double _fontSize = 20.0; // Initial font size
  TextEditingController _controller = TextEditingController(text: "hii");

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: mq.width,
        height: mq.height * 0.6,
        color: Colors.red,
        child: 1 == 0
            ? SizedBox(height: 15)
            : LayoutBuilder(
                builder: (context, constraints) {
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth,
                        maxHeight:
                            5 * _fontSize, // Maximum height for 5 lines of text
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: 5,
                        onChanged: (value) {
                          setState(() {
                            _fontSize =
                                calculateFontSize(value, constraints.maxHeight);
                          });
                        },
                        style: TextStyle(fontSize: _fontSize),
                        decoration: InputDecoration(
                          hintText: 'Enter text...',
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  double calculateFontSize(String text, double maxHeight) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: _fontSize),
      ),
      maxLines: 5,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);

    if (textPainter.size.height > maxHeight) {
      while (textPainter.size.height > maxHeight && _fontSize > 10) {
        setState(() {
          _fontSize--;
        });
        textPainter.text = TextSpan(
          text: text,
          style: TextStyle(fontSize: _fontSize),
        );
        textPainter.layout(maxWidth: double.infinity);
      }
    } else {
      while (textPainter.size.height < maxHeight && _fontSize < 100) {
        setState(() {
          _fontSize++;
        });
        textPainter.text = TextSpan(
          text: text,
          style: TextStyle(fontSize: _fontSize),
        );
        textPainter.layout(maxWidth: double.infinity);
      }
      setState(() {
        _fontSize--;
      });
    }
    return _fontSize;
  }
}
