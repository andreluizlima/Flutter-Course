import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);

  Function(String) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  var _controller = TextEditingController();
  bool _isComposing = false;

  // Limpar campo de envio de mensagem
  void _resetComposer(){
    _controller.clear();
    setState(() {
      _isComposing = _controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: (){

            },            
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(hintText: "Digite uma mensagem"),
              onChanged: (vl){
                setState(() {
                  _isComposing = vl.isNotEmpty;
                });
              },
              onSubmitted: (vl){
                widget.sendMessage(vl);
                _resetComposer();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? (){
              widget.sendMessage(_controller.text);
              _resetComposer();
            } : null,
          )
        ],
      ),
    );
  }
}