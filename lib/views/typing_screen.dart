import 'package:enotes/models/note_model.dart';
import 'package:enotes/services/sqlite_crud.dart';
import 'package:enotes/utils/close_screen.dart';
import 'package:enotes/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TypingScreen extends StatefulWidget {
  int? noteId;
  String? noteTitle;
  String? noteContent;
  int lastId;

  TypingScreen(
      {super.key,
      this.noteId,
      this.noteTitle,
      this.noteContent,
      this.lastId = 0});

  @override
  State<TypingScreen> createState() => _TypingScreenState();
}

class _TypingScreenState extends State<TypingScreen> {
  String title = "";
  String content = "";
  var titleController = TextEditingController();
  var contentController = TextEditingController();
  bool showCheckBtn = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.noteId != null) {
      titleController.text = widget.noteTitle.toString();
      title = widget.noteTitle.toString();
      contentController.text = widget.noteContent.toString();
      content = widget.noteContent.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(1, 1),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Icon(Icons.arrow_back),
                    onTap: () {
                      closeScreen(context);
                    },
                  ),
                  showCheckBtn
                      ? GestureDetector(
                          child: Icon(Icons.check),
                          onTap: () async {
                            String formattedDate =
                                DateFormat('kk:mm EEE, M/d/y')
                                    .format(DateTime.now());
                            var note = Note(
                              id: widget.lastId,
                              title: title,
                              content: content,
                              timestamp: formattedDate,
                            );
                            await insertNote(note);
                            snackBar(context, "Saved");
                          },
                        )
                      : SizedBox(),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Title here',
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsetsDirectional.only(start: 10.0),
                    ),
                    style: const TextStyle(fontSize: 20),
                    onChanged: (text) {
                      title = text;
                      if(!showCheckBtn){
                        setState(() {
                          showCheckBtn = true;
                        });
                      }else{
                        if(content.length == 0 && title.length == 0){
                          setState(() {
                            showCheckBtn = false;
                          });
                        }
                      }
                    },
                    controller: titleController,
                  ),
                  TextField(
                    minLines: 10,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Start typing',
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsetsDirectional.only(start: 10.0),
                    ),
                    onChanged: (text) {
                      content = text;
                      if(!showCheckBtn){
                        setState(() {
                          showCheckBtn = true;
                        });
                      }else{
                        if(content.length == 0 && title.length == 0){
                          setState(() {
                            showCheckBtn = false;
                          });
                        }
                      }
                    },
                    controller: contentController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
