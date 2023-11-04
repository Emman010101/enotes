class Note {
  int id;
  String title;
  String content;
  String timestamp;

  Note({required this.id ,required this.title, required this.content, required this.timestamp});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
