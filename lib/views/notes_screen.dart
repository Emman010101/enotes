import 'package:enotes/views/typing_screen.dart';
import 'package:enotes/services/sqlite_crud.dart';
import 'package:enotes/utils/open_screen.dart';
import 'package:flutter/material.dart';

import '../models/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note>? listOfNotes;
  bool isDeleteActivated = false;
  List<bool> isChecked = [];
  bool dataFetchFinished = false;

  Future notes() async {
    listOfNotes = await readNotes();
    setState(() {
      dataFetchFinished = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    notes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 70),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: !dataFetchFinished
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    )
                  : ListView.builder(
                      itemCount: listOfNotes?.length,
                      itemBuilder: (context, index) {
                        if (isChecked.length != listOfNotes?.length) {
                          isChecked.add(false);
                        }
                        return Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(15),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
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
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listOfNotes![index].title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            listOfNotes![index].content,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            listOfNotes![index].timestamp,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    isDeleteActivated
                                        ? Checkbox(
                                            checkColor: Colors.black,
                                            activeColor: Colors.grey,
                                            value: isChecked[index],
                                            onChanged: (bool? value) {
                                              bool noChecked = true;
                                              setState(() {
                                                isChecked[index] = value!;
                                                for(int i = 0; i < isChecked.length; i++){
                                                  if(isChecked[i]){
                                                    noChecked = false;
                                                  }
                                                }
                                                if(noChecked){
                                                  isDeleteActivated = false;
                                                }
                                              });
                                            },
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                if(isDeleteActivated){
                                  setState(() {
                                    if(isChecked[index]){
                                      isChecked[index] = false;
                                      bool noChecked = true;
                                      for(int i = 0; i < isChecked.length; i++){
                                        if(isChecked[i]){
                                          noChecked = false;
                                        }
                                      }
                                      if(noChecked){
                                        isDeleteActivated = false;
                                      }
                                    }else{
                                      isChecked[index] = true;
                                    }
                                  });
                                }else{
                                  await openScreen(
                                      context,
                                      TypingScreen(
                                        noteId: listOfNotes?[index].id,
                                        noteContent: listOfNotes?[index].content,
                                        noteTitle: listOfNotes?[index].title,
                                      ));
                                  setState(() {
                                    notes();
                                  });
                                }
                              },
                              onLongPress: () {
                                if (!isDeleteActivated) {
                                  setState(() {
                                    isDeleteActivated = true;
                                    isChecked[index] = true;
                                  });
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(15),
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
                  children: [
                    Text("Enotes",style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                    Spacer(),
                    isDeleteActivated ? GestureDetector(
                      child: Icon(Icons.restore_from_trash),
                      onTap: () async {
                        var idOfItemsToBeDeleted = [];
                        for(int i = 0; i < isChecked.length; i++){
                          if(isChecked[i]){
                            idOfItemsToBeDeleted.add(listOfNotes![i].id);
                          }
                        }
                        if(idOfItemsToBeDeleted.isNotEmpty){
                          await deleteNotes(idOfItemsToBeDeleted);
                          setState(() {
                            isDeleteActivated = false;
                            isChecked.clear();
                            notes();
                          });
                        }
                      },
                    ) : SizedBox(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<Note> list_of_notes = await readNotes();
          await openScreen(
              context,
              TypingScreen(
                lastId: list_of_notes.length == 0
                    ? 0
                    : list_of_notes[list_of_notes.length - 1].id + 1,
              ));
          setState(() {
            notes();
          });
        },
        tooltip: 'Add Notes',
        child: const Icon(Icons.add),
      ),
    );
  }
}
